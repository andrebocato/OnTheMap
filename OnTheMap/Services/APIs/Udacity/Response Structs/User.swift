//
//  User.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 21/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let lastName: String
    let firstName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
    }
    
}

