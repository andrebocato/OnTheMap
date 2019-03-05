//
//  OnTheMap.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 14/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

class UdacityClient {
    
    private init() {}
    
    // MARK: - Properties
    
    struct URLParameters {
        // URL parameters
        static let apiHost = "onthemap-api.udacity.com"
        static let apiPath = "/v1"
        
        // API Methods
        static let sessionId = "/session"       // POST to get sessions ID and DELETE to delete session
        static let userId = "/users"            // GET user ID
    }
    
    // MARK: - Functions
    
    static func postSessionRequest(withUsername username: String,
                                   password: String,
                                   success: @escaping (_ response: SessionResponse?) -> Void,
                                   failure: @escaping (Error?) -> Void) {
        
        // build jsonBody for POSTing
        let parameters = ["udacity": ["username": username, "password": password] ]
        
        RequestHelper.taskForHTTPMethod(.post, inAPI: .udacity, withPathExtension: URLParameters.sessionId, parameters: parameters) { (optionalResponse, optionalError) in
            
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            do {
                let serializedResponse = try RequestHelper.serializeResponse(optionalResponse, ofType: SessionResponse.self)
                success(serializedResponse)
            } catch {
                failure(error)
            }
            
        }
    }
    
    static func deleteSesionRequest(success: @escaping (_ response: SessionResponse?) -> Void,
                                    failure: @escaping (Error?) -> Void) {
        
        RequestHelper.taskForHTTPMethod(.delete, inAPI: .udacity, withPathExtension: URLParameters.sessionId) { (optionalResponse, optionalError) in
            
            // check for errors
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            do {
                let serializedResponse = try RequestHelper.serializeResponse(optionalResponse, ofType: SessionResponse.self)
                success(serializedResponse)
            } catch {
                failure(error)
            }
            
        }
    }
    
    static func getUserRequest(withId id: String,
                                 success: @escaping (_ response: User?) -> Void,
                                 failure: @escaping (Error?) -> Void) {
        
        let pathExtension = URLParameters.userId + "/" + id
        
        RequestHelper.taskForHTTPMethod(.get, inAPI: .udacity, withPathExtension: pathExtension) { (optionalResponse, optionalError) in
            
            // check for errors
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            // serialize response
            guard let responseDictionary = optionalResponse as? [String: Any],
                let data = try? JSONSerialization.data(withJSONObject: responseDictionary, options: .prettyPrinted),
                let serializedResponse = try? JSONDecoder().decode(User?.self, from: data) else {
                    
                let userInfo = [NSLocalizedDescriptionKey: "Empty response"]
                let error = NSError(domain: "UdacityClient", code: 1, userInfo: userInfo)
                failure(error)
                
                return
            }
            
            // handle successfully serialized response (User)
            success(serializedResponse)
            
        }
    }
    
}





