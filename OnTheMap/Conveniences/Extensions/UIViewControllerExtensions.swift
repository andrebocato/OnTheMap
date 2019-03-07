//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 05/03/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func validateInputsFor(textFields: [UITextField],
                             withErrorLabels errorLabels: [UILabel],
                             completion: ((Bool) -> Void)) {
        
        guard (textFields.count == errorLabels.count) else { return }
        
        var validFields = 0
        zip(textFields, errorLabels).forEach { (textField, errorLabel) in
            if !textField.hasValidInput() {
                errorLabel.text = "This field must not be empty."
            } else {
                validFields += 1
            }
        }
        
        completion(validFields == textFields.count)
    }
    
}
