//
//  Student.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 19/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

struct Student: Codable {
    
    var createdAt: String
    var updatedAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String?
    var uniqueKey: String
    
}
