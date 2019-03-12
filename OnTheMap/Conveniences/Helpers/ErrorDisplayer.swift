//
//  ErrorDisplayer.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 05/03/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import UIKit

protocol ErrorLogger {
    func logError(_ error: Error, description: String?)
}

extension ErrorLogger {
    
    func logError(_ error: Error,
                  description: String? = nil) {
        
        if let description = description {
            print(description + "\nError: \(error)")
        } else {
            print("An unknown error occurred. Error: \(error)")
        }
    }
    
}

extension UIViewController: ErrorLogger { }
