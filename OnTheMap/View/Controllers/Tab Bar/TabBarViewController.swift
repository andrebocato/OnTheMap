//
//  OnTheMapTabBarControllerViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//
// @TODO: implement 'logging out' activityIndicatorView

import Foundation
import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - IBActions
    
    @IBAction private func logoutBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        UdacityClient.deleteSesionRequest(success: { (logoutResponse) in
            // treat logoutResponse
            if let sessionId = logoutResponse?.session.id {
                print(sessionId)
            }
            
            DispatchQueue.main.async {
                // should go back to LoginViewController
                print("logout button tapped. let's pretend you're logging out now")
            }
            
        }, failure: { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Logout request failed.")
            }
        } )
    }
    
    @IBAction private func refreshBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        // @TODO: refresh tableview content
        // @TODO: refresh mapview content
        print("refresh button pressed")
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
    
}
