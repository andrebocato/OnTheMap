//
//  UIViewExtensions.swift
//  OnTheMap
//
//  Created by Andre Sanches Bocato on 12/03/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import UIKit

extension UIView {
    
    func configureUIForLoading(_ isLoading: Bool,
                               _ activityIndicator: UIActivityIndicatorView,
                               _ button: UIButton) {
        
        DispatchQueue.main.async {
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            activityIndicator.isHidden = !isLoading
            button.isEnabled = !isLoading
        }
    }
    
}
