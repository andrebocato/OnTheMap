//
//  OnTheMapTabBarControllerViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//
// @TODO: inform user if download fails
// @TODO: show downloaded data in mapview and tableview. actually returning empty arrays

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - IBActions
    
    @IBAction private func logoutBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        UdacityClient.deleteSesionRequest(success: { (logoutResponse) in
            CurrentSessionData.shared.clearSessionData()
            // should go back to login view
        }, failure: { (optionalError) in
            if let error = optionalError {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Logout failed.")
                self.displayError(error, description: "Logout request failed.")
            }
        }) // end of DELETE request
        
        if let controller = selectedViewController {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func refreshBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        if let controller = selectedViewController as? DataRefreshable {
            controller.refreshData()
        }
    }
    
    // MARK: - Helper Functions
    
    // @TODO: Refactor, repeated code
    private func displayError(_ error: Error, description: String? = nil) {
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
}
