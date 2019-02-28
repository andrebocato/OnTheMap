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
    
    private var students = [Student]()
    private var annotations = [MKAnnotation]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        fetchStudents()
        addStudentsAnnotations()
        
    }
    
    // MARK: - Helper Functions
    
    // @TODO: Refactor, repeated code
    private func displayError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
    // @TODO: Refactor, repeated code
    private func fetchStudents() {
        
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
    
    private func addStudentsAnnotations() {
        for student in students {
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
}

// MARK: - Extensions

extension MapViewController: MKMapViewDelegate, DataRefreshable {
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if let pin = pinView {
            pin.annotation = annotation
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
    
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - DataRefreshable protocol stubs
    
    func refreshData() {
        mapView.removeAnnotations(mapView.annotations)
        fetchStudents()
        addStudentsAnnotations()
    }
    
}
