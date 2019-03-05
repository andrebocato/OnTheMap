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

class SubmitLocationViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    let currentUser = CurrentSessionData.shared.user!
    var currentStudentObjectId: String?
    
    var location = ""               // receiving data from InformationPostingViewController
    var link = ""                   // receiving data from InformationPostingViewController
    var latitude = Double()         // receiving data from InformationPostingViewController
    var longitude = Double()        // receiving data from InformationPostingViewController
    
    var studentDoesExist = Bool()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // @TODO: send mapView to (latitude, longitude) received from InformationPostingViewController
        let receivedCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.setCenter(receivedCoordinates, animated: true)
        
        // refactor: create new button type
        submitButton.layer.cornerRadius = 15
    }
    
    // MARK: - IBActions
    
    @IBAction private func finishButtonDidReceiveTouchUpInside(_ sender: Any) {
        
        self.searchStudent(withKey: currentUser.key)
        
        if studentDoesExist == true { // objectId from response != nil
            
            // PUT request with student's objectId
            ParseClient.putStudentRequest(withObjectId: currentStudentObjectId!, success: { (putStudentResponse) in
                // @TODO: update student parameters (mapstring, mediaURL, latitude, longitude)
            }) { (optionalError) in
                if let error = optionalError {
                    Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to update student data.")
                    self.logError(error, description: "Failed to PUT student.")
                }
            } // end of PUT request
            
        } else { // objectId from response == nil
            
            let parametersForPOSTing: [String: Any] = [
                "uniqueKey": currentUser.key,
                "firstName": currentUser.firstName,
                "lastName": currentUser.lastName,
                "mapString": location,
                "mediaURL": link,
                "latitude": latitude,
                "longitude": longitude
            ]
            
            // POST request with 'parameters'
            ParseClient.postStudentRequest(withParameters: parametersForPOSTing, success: { (postStudentResponse) in
                if let objectIdFromResponse = postStudentResponse?.objectId {
                    self.currentStudentObjectId = objectIdFromResponse
                }
            }) { (optionalError) in
                if let error = optionalError {
                    Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to post student data.")
                    self.logError(error, description: "Failed to POST student.")
                }
            } // end of POST request
        }
        
        DispatchQueue.main.async {            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Helper Functions
    
    // @TODO: Refactor, repeated code
    private func logError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
    // sets boolean state of 'studentDoesExist' and 'currentStudentObjectId' value (if it's not nil)
    private func searchStudent(withKey key: String) {
        // GET student request
        ParseClient.getStudentRequest(withUniqueKey: currentUser.key, success: { (getStudentResponse) in
            guard let responseArray = getStudentResponse?.results, !responseArray.isEmpty else {
                self.studentDoesExist = false
                return
            }
            
            let id = responseArray.first?.objectId
            self.studentDoesExist = true
            self.currentStudentObjectId = id
            
        }) { (optionalError) in
            if let error = optionalError {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to download student data.")
                self.logError(error, description: "Failed to GET student.")
            }
        } // end of GET request
    }
    
}

// MARK: - Extensions

extension SubmitLocationViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if let pinView = pinView {
            pinView.annotation = annotation
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
