//
//  UITextFieldExtensions.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 05/03/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import UIKit

extension UITextField {
    
    func hasValidInput() -> Bool {
        guard let input = text, !input.isEmpty else {
            return false
        }
        return true
    }
    
}
