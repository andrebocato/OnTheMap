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
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet private weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 15
        }
    }
    
    // MARK: - Properties
    
    let currentUser = CurrentSessionData.shared.user!
    var currentStudentObjectId: String?
    
    var location = ""               // receiving data from InformationPostingViewController
    var link = ""                   // receiving data from InformationPostingViewController
    var latitude = Double()         // receiving data from InformationPostingViewController
    var longitude = Double()        // receiving data from InformationPostingViewController
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let receivedCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.setCenter(receivedCoordinates, animated: true)
        
        let region = MKCoordinateRegion(center: receivedCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = receivedCoordinates
        mapView.addAnnotation(annotation)
        
    }
    
    // MARK: - Functions
    
    func createNewStudent(onSuccess: ((_ id: String) -> Void)? = nil) {
        
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
        ParseClient.postStudentRequest(withParameters: parametersForPOSTing, success: { [weak self] (postStudentResponse) in
            
            guard let id = postStudentResponse?.objectId else {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Unexpected error.")
                return
            }
            
            onSuccess?(id)
            
        }) { [weak self] (optionalError) in
            guard let error = optionalError else { return }
            
            Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to post student data.", okCompletion: {
                self?.navigationController?.popViewController(animated: true)
            })
            
            self?.logError(error, description: "Failed to POST student.")
        } // end of POST request
        
    }
    
    func updateStudent(with id: String, onSuccess: ((_ response: PutStudentResponse) -> Void)? = nil) {
        
        // PUT request with student's objectId
        
        let parameters: [String: Any] = [
            "mapString": location,
            "mediaURL": link,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        ParseClient.putStudentRequest(withObjectId: id, withParameters: parameters, success: { [weak self] (putStudentResponse) in
            
            guard let putStudentResponse = putStudentResponse else {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Unexpected error.")
                return
            }
            
            onSuccess?(putStudentResponse)
            
        }) { [weak self] (optionalError) in
            guard let error = optionalError else { return }
            Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to update student data.")
            self?.logError(error, description: "Failed to PUT student.")
        } // end of PUT request
        
    }
    
    private func searchStudent(withKey key: String,
                               onSuccess: @escaping (_ objectID: String?) -> ()) {
        // @TODO:
        // check if student is already saved in CurrentSession singleton
        // if user exists, fetch data from singleton
        // else, GET student and store data
        
        // GET student request
        ParseClient.getStudentRequest(withUniqueKey: currentUser.key, success: { (getStudentResponse) in
            
            guard let id = getStudentResponse?.results.first?.objectId else {
                onSuccess(nil)
                return
            }
            
            onSuccess(id)
            
        }) { [weak self] (optionalError) in
            if let error = optionalError {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to download student data.")
                self?.logError(error, description: "Failed to GET student.")
            }
        } // end of GET request
    }
    
    // MARK: - IBActions
    
    @IBAction private func finishButtonDidReceiveTouchUpInside(_ sender: Any) {
        
        searchStudent(withKey: currentUser.key) { [weak self] (id) in
            
            guard let id = id else {
                self?.createNewStudent { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
                return
            }
            
            self?.updateStudent(with: id, onSuccess: { (response) in
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
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
