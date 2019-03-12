//
//  RequestHelper.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 18/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

// MARK: - Enums

enum HTTPMethod: String {
    case get
    case post
    case delete
    case put
    
    var name: String {
        return self.rawValue.uppercased()
    }
}

enum API {
    case udacity
    case parse
}

// MARK: - Class

class RequestHelper {
    
    private init() {}
    
    // MARK: - Networking functions
    
    @discardableResult      // result won't necessarily be used
    static func taskForHTTPMethod(_ method: HTTPMethod,
                                  inAPI api: API,
                                  withPathExtension path: String?,
                                  parameters: [String: Any]? = nil,
                                  completionHandler: @escaping (_ result: Any?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let url = createURLForAPI(api: api, parameters: parameters, withPathExtension: path)
        var request = NSMutableURLRequest(url: url)
        configureHTTPHeaders(for: request, using: api, method: method)
        configureRequest(&request, for: method, using: api, parameters: parameters)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            switch api {
            case .udacity:
                let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
                self.handleErrorsAndConverData(error, response as? HTTPURLResponse, newData, completionHandler)
            case .parse:
                self.handleErrorsAndConverData(error, response as? HTTPURLResponse, data, completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    private static func configureRequest(_ request: inout NSMutableURLRequest,
                                         for method: HTTPMethod,
                                         using api: API,
                                         parameters: [String: Any]? = nil) {
        
        // Common stuff
        request.httpMethod = method.name
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        // Specific stuff
        switch (method, api) {
        case (.delete, .udacity):
            // stuff for DELETE task
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        default: return
        }
    }
    
    // MARK: - Helper Functions
    
    private static func createURLForAPI(api: API,
                                        parameters: [String: Any]? = nil,
                                        withPathExtension pathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        switch api {
        case .udacity:
            components.host = UdacityClient.URLParameters.apiHost
            if let pathExtension = pathExtension {
                components.path = UdacityClient.URLParameters.apiPath + pathExtension
            }
        case .parse:
            components.host = ParseClient.URLParameters.apiHost
            if let pathExtension = pathExtension {
                components.path = ParseClient.URLParameters.apiPath + pathExtension
            }
        }
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    private static func convertDataWithCompletionHandler(_ data: Data,
                                                         completionHandlerForConvertData: (_ result: Any?, _ error: NSError?) -> Void ) {
        var parsedResult: Any? = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as Any
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private static func sendError(_ error: String,
                                  _ completionHandler: (_ result: Any?, _ error: NSError?) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey: error]
        completionHandler(nil, NSError(domain: "taskForMethod", code: 1, userInfo: userInfo))
    }
    
    private static func handleErrorsAndConverData(_ error: Error?,
                                                  _ response: HTTPURLResponse?,
                                                  _ data: Data?,
                                                  _ completionHandler: (Any?, NSError?) -> Void) {
        // GUARD: Was there an error?
        guard error == nil else {
            self.sendError("There was an error with your request: \(error!)", completionHandler)
            return
        }
        
        // GUARD: Did we get a successful 2XX response?
        guard let statusCode = (response )?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            self.sendError("Your request returned a status code other than 2xx!", completionHandler)
            return
        }
        
        // GUARD: Was there any data returned?
        guard let data = data else {
            self.sendError("No data was returned by the request!", completionHandler)
            return
        }
        
        self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
    }
    
    private static func configureHTTPHeaders(for request: NSMutableURLRequest,
                                             using api: API, method: HTTPMethod) {
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        switch api {
        case .parse:
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        default: return
        }
        
        switch (method, api) {
        case (.post, .parse), (.put, .parse):
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        default: return
        }
        
        
    }
    
}

extension RequestHelper {
    
    class func serializeResponse<T: Codable>(_ response: Any?, ofType: T.Type) throws ->  T {
        
        do {
            guard let response = response else {
                let userInfo = [NSLocalizedDescriptionKey: "Empty response"]
                throw NSError(domain: "RequestHelper", code: -1, userInfo: userInfo)
            }
            
            let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let serializedResponse = try JSONDecoder().decode(T.self, from: data)
            
            return serializedResponse
            
        } catch {
            throw error
        }
        
    }
    
}
