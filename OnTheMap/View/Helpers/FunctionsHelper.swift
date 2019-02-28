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
    
    // @TODO: Refactor, gross function
    static func checkForEmptyText(_ textField: UITextField, _ label: UILabel) {
        guard let text = textField.text, !text.isEmpty else {
            label.isHidden = false
            label.text = "This field must not be empty."
            return
        }
        label.isHidden = true
    }
    
}
