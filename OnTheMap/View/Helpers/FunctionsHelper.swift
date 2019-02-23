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
import MapKit

// Functions that are used in different view controllers. Created to avoid repeated code.

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

    // MARK: - Attributed text configuration

    // Refactor: shouldn't be here
//    static func setUpAttributedText(student: Student) -> NSMutableAttributedString {
//        let attributedString = NSMutableAttributedString(string: student.firstName + student.lastName)
//        let line2AttributedString = NSAttributedString(string: student.mediaURL, attributes: nil)
//        attributedString.append(line2AttributedString)
//        return attributedString
//    }
    
}
