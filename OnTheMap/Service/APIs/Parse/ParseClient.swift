//
//  ParseClient.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 18/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

class URLHelper {
    
    static func escapedParameters(_ parameters: [String: Any]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                // make sure that it is a string value
                let stringValue = "\(value)"
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
}

class ParseClient {
    
    private init() {}
    
    // MARK: - Properties
    
    struct URLParameters {
        // ApplicationID and ApiKey
        static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // URL parameters
        static let apiHost = "parse.udacity.com"
        static let apiPath = "/parse/classes"
        
        // API Methods
        static let studentLocation = "/StudentLocation"                     // GET multiple or single student locations, POST student location, PUT student location (update)
    }
    
    // MARK: - Functions
    
    static func getStudentsRequest(limit: Int = 100,
                                   skip: Int? = nil,
                                   order: String,
                                   success: @escaping (_ students: GetStudentsResponse?) -> Void,
                                   failure: @escaping (Error?) -> Void) {
        
        var parameters = [String: Any]()
        parameters["limit"] = limit
        if let skip = skip {
           parameters["skip"] = skip
        }
        parameters["order"] = order
        
        RequestHelper.taskForHTTPMethod(.get, inAPI: .parse, withPathExtension: URLParameters.studentLocation, parameters: parameters) { (optionalResponse, optionalError) in
        
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
//            do {
//                let data = try JSONSerialization.data(withJSONObject: optionalResponse, options: [])
//                debugPrint("data = \(data)")
//
//                let jsonRaw = try JSONSerialization.jsonObject(with: data, options: [])
//                debugPrint("Raw = \(jsonRaw)")
//                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]]
//                debugPrint("Raw = \(jsonArray ?? [])")
//                let jsonDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                debugPrint("Raw = \(jsonDic ?? [:])")
//
//
//                let dataExample = try JSONDecoder().decode(GetStudentsResponse.self, from: data)
//                debugPrint(dataExample)
//            } catch {
//                failure(error)
//            }
//
            do {
                let serializedResponse = try RequestHelper.serializeResponse(optionalResponse, ofType: GetStudentsResponse.self)
                success(serializedResponse)
            } catch {
                failure(error)
            }
            
        }
        
    }
    
    static func getStudentRequest(withUniqueKey uniqueKey: String,
                                  success: @escaping (_ student: GetStudentResponse?) -> Void,
                                  failure: @escaping (Error?) -> Void) {
        
        let path = URLHelper.escapedParameters(["where": ["{uniqueKey": "\(uniqueKey)}"]])
        
        let pathExtension = URLParameters.studentLocation + path
        
        RequestHelper.taskForHTTPMethod(.get, inAPI: .parse, withPathExtension: pathExtension) { (optionalResponse, optionalError) in
            
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            do {
                let serializedResponse = try RequestHelper.serializeResponse(optionalResponse, ofType: GetStudentResponse.self)
                success(serializedResponse)
            } catch {
                failure(error)
            }
            
        }
    }
    
    static func postStudentRequest(withParameters parameters: [String: Any],
                                   success: @escaping (_ students: PostStudentResponse?) -> Void,
                                   failure: @escaping (Error?) -> Void) {
        
        
//        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//        request.httpMethod = "POST"
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)//"{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//
//            // check for error and handle failure with given error
//            guard error == nil else {
//                failure(error)
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                let rawResponse = String(data: data, encoding: .utf8)!
//                debugPrint(rawResponse)
//                let serializedResponse = try JSONDecoder().decode(PostStudentResponse.self, from: data)
//                success(serializedResponse)
//            } catch {
//                failure(error)
//            }
//
//        }
//        task.resume()
        
        RequestHelper.taskForHTTPMethod(.post, inAPI: .parse, withPathExtension: URLParameters.studentLocation, parameters: parameters) { (optionalResponse, optionalError) in

            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }

            do {
                let serializedResponse = try RequestHelper.serializeResponse(optionalResponse, ofType: PostStudentResponse.self)
                success(serializedResponse)
            } catch {
                failure(error)
            }

        }
    }
    
    static func putStudentRequest(withObjectId objectId: String,
                                  withParameters parameters: [String: Any],
                                  success: @escaping (_ students: PutStudentResponse?) -> Void,
                                  failure: @escaping (Error?) -> Void) {
        
        let pathExtension = URLParameters.studentLocation + "/" + objectId
        
        RequestHelper.taskForHTTPMethod(.put, inAPI: .parse, withPathExtension: pathExtension, parameters: parameters) { (optionalResponse, optionalError) in
            
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            do {
                let serializedResponse = try RequestHelper.serializeResponse(optionalResponse, ofType: PutStudentResponse.self)
                success(serializedResponse)
            } catch {
                failure(error)
            }
            
        }
    }
    
}
