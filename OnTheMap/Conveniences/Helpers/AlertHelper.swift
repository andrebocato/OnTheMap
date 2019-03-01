//
//  AlertHelper.swift
//  OnTheMap
//
//  Created by Andre Sanches Bocato on 28/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import UIKit

class Alerthelper {
    
    private init() {}
    
    // MARK: - Functions
    
    static func showErrorAlert(inController controller: UIViewController,
                               withMessage message: String) {
        
        let errorAlert = UIAlertController(title: "An error has occurred", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            errorAlert.dismiss(animated: true, completion: nil)
        }
        errorAlert.addAction(okAction)
        
        controller.present(errorAlert, animated: true, completion: nil)
    }
    
}
