//
//  LayoutFunctionsHelper.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 14/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//
// @TODO: refactor to a logicController

import Foundation
import UIKit

// @TODO: Exterminate!!!

class FunctionsHelper {
    
    private init() {}
    
    // MARK: - UI Configuration functions
    
    static func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
    }
    
    static func checkForEmptyText(_ textField: UITextField, _ label: UILabel) {
        if textField.text == "" {
            label.isHidden = false
            label.text = "This field must not be empty."
        } else {
            label.isHidden = true
        }
    }
    
}
