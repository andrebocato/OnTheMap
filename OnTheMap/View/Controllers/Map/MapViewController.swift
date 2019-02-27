//
//  MapViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    private var students: [Student]?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // GET request for students
        ParseClient.getStudentsRequest(limit: 100, skip: 100, order: "-updatedAt", success: { (getStudentsResponse) in
            if let studentsArrayFromResponse = getStudentsResponse?.results {
                self.students = studentsArrayFromResponse
            }
        }) { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Failed to GET students.")
            }
        } // end of GET students request
        
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

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    
    
}
