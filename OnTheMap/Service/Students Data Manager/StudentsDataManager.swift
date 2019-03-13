//
//  StudentsDataManager.swift
//  OnTheMap
//
//  Created by Andre Sanches Bocato on 13/03/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation

class StudentsDataManager {
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Shared Instance
    
    static let shared = StudentsDataManager()
    
    // MARK: - Properties
    
    private(set) var students: [Student]?
    
    // MARK: - Functions
    
    func save(studentsArray: [Student]) {
        students = studentsArray
    }
    
}
