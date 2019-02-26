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
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var finishButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // @TODO: receive latitude and longitude from previous screen then send map to this coordinate pair
        
        mapView.delegate = self
        FunctionsHelper.configureButton(finishButton)
    }
    
    // MARK: - IBActions
    
    @IBAction private func finishButtonDidReceiveTouchUpInside(_ sender: Any) {
        
        // @TODO: determine wether should make POST or PUT request
        
        let parameters: [String: Any] = [
            "uniqueKey": CurrentSessionData.shared.user!.key,
            "firstName": CurrentSessionData.shared.user!.firstName,
            "lastName": CurrentSessionData.shared.user!.lastName,
            "mapString": "locationTextField.text (from InformationPostingVC)",
            "mediaURL": "linkTextField.tet (from InformationPostingVC)",
            "latitude": "latitude from mapView (Double)",
            "longitude": "longitude from mapView (Double)"
        ]
        
        // POST request with 'parameters'
        ParseClient.postStudentRequest(with: parameters, success: { (postStudentResponse) in
            // treat response
        }) { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Failed to POST student.")
            }
        } // end of POST request
        
        // set objectId
        let objectId = "" // setting to avoid error
        
        // PUT request with student's objectId
        ParseClient.putStudentRequest(with: objectId, success: { (putStudentResponse) in
            // treat response
        }) { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Failed to PUT student.")
            }
        } // end of PUT request
        
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
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

// MARK: - Extensions

extension ConfirmLocationViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    
    
}
