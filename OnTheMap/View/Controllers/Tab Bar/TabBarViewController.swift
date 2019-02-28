//
//  OnTheMapTabBarControllerViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

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
                self.displayError(error, description: "Logout request failed.")
            }
        })
        // end of DELETE request
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction private func refreshBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        guard let refreshableController = selectedViewController as? DataRefreshable else { return }
        refreshableController.refreshData()
    }
    
    // MARK: - Helper Functions
    
    // repeated code
    private func displayError(_ error: Error, description: String? = nil) {
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
    private func relodData() {
        
     
        
    }
    
    
}
