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
    
    static func showErrorAlert(inController controller: UIViewController?,
                               withMessage message: String,
                               okCompletion: (() -> Void)? = nil) {
        
        let errorAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            errorAlert.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    okCompletion?()
                }
            })
        }
        errorAlert.addAction(okAction)
        
        DispatchQueue.main.async {
             controller?.present(errorAlert, animated: true, completion: nil)
        }
    }
    
}
