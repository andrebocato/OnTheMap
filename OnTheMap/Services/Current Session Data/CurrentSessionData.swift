//
//  CurrentSessionData.swift
//  OnTheMap
//
//  Created by Andre Sanches Bocato on 25/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

class CurrentSessionData {
    
    // MARK: - Shared Instance
    
    static let shared = CurrentSessionData()
    
    // MARK: - Properties
    
    var user: User?
    var session: SessionResponse?
    
    // MARK: - Functions
    
    func clearSessionData() {
        user = nil
        session = nil
    }
    
}
