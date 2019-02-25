//
//  ParseClient.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 18/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

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
        static let studentLocation = "/StudentLocation"                     // GET multiple or single student locations, POST student location
        static let studentLocationObjectId = "/StudentLocation"             // PUT student location (update)
    }
    
    // MARK: - Functions
    
    static func getStudentsRequest(limit: Int,
                                   skip: Int,
                                   order: String,
                                   success: @escaping (_ students: GetStudentsResponse?) -> Void,
                                   failure: @escaping (Error?) -> Void) {
        
        RequestHelper.taskForHTTPMethod(.get, inAPI: .parse, withPathExtension: URLParameters.studentLocation) { (optionalResponse, optionalError) in
            
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            // take care of the response and check for errors
            guard let response = optionalResponse,
                let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                let serializedResponse = try? JSONDecoder().decode(GetStudentsResponse.self, from: data) else {
                    
                let userInfo = [NSLocalizedDescriptionKey: "Empty response"]
                let error = NSError(domain: "ParseClient", code: 1, userInfo: userInfo)
                failure(error)
                    
                return
            }
            
            // handle successfully serialized response
            success(serializedResponse)
        }
        
    }
    
    static func getStudentRequest(with uniqueKey: String,
                                  success: @escaping (_ student: GetStudentResponse?) -> Void,
                                  failure: @escaping (Error?) -> Void) {
        
        RequestHelper.taskForHTTPMethod(.get, inAPI: .parse, withPathExtension: URLParameters.studentLocation) { (optionalResponse, optionalError) in
            
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
        
            guard let response = optionalResponse,
                let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                let serializedResponse = try? JSONDecoder().decode(GetStudentResponse.self, from: data) else {
                
                let userInfo = [NSLocalizedDescriptionKey: "Empty response"]
                let error = NSError(domain: "ParseClient", code: 1, userInfo: userInfo)
                failure(error)
                
                return
            }
            
            // handle successfully serialized response
            success(serializedResponse)
        }
    }
    
    static func putStudentRequest(with objectId: String,
                                  success: @escaping (_ students: PutStudentResponse?) -> Void,
                                  failure: @escaping (Error?) -> Void) {
        
        let pathExtension = URLParameters.studentLocationObjectId + "/" + objectId
        
        RequestHelper.taskForHTTPMethod(.put, inAPI: .parse, withPathExtension: pathExtension) { (optionalResponse, optionalError) in
            
            // check for error and handle failure with given error
            guard optionalError == nil else {
                failure(optionalError)
                return
            }
            
            guard let response = optionalResponse,
                let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                let serializedResponse = try? JSONDecoder().decode(PutStudentResponse.self, from: data) else {
                    
                    let userInfo = [NSLocalizedDescriptionKey: "Empty response"]
                    let error = NSError(domain: "ParseClient", code: 1, userInfo: userInfo)
                    failure(error)
                    
                    return
            }
            
            // handle successfully serialized response
            success(serializedResponse)
        }
    }
    
}
