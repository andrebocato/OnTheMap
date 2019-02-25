//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapItem!
    @IBOutlet private weak var finishButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction private func finishButtonDidReceiveTouchUpInside(_ sender: Any) {
        // @TODO: fetch objectId where you stored it right after
        let objectId = ""
        
        ParseClient.putStudentRequest(with: objectId, success: { (putStudentResponse) in
            // @TODO: treat putStudentResponse
            
        }) { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Failed to PUT student.")
            }
            
        } // end of PUT request
        
        
        // @TODO: dismiss view and pop back to tab bar view
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FunctionsHelper.configureButton(finishButton)
    }
    
    // MARK: - Helper Functions
    
    // repeated code
    private func displayError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
}
