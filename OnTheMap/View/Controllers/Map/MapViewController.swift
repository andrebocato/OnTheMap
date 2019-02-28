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

class MapViewController: UIViewController, DataRefreshable {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    private var students = [Student]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMapData()
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
    
    // repeated code
    private func fetchStudents(completion: ((_ error: Error?) -> Void)? = nil) {
        
        // GET request for students
        ParseClient.getStudentsRequest(limit: 100, skip: 100, order: "-updatedAt", success: { (getStudentsResponse) in
            if let studentsArrayFromResponse = getStudentsResponse?.results {
                self.students = studentsArrayFromResponse
                completion?(nil)
            }
        }) { (optionalError) in
            if let error = optionalError {
                self.displayError(error, description: "Failed to GET students.")
                completion?(error)
            }
        } // end of GET students request
        
    }
    
    private func loadMapData() {
        fetchStudents() { [weak self] _ in
            guard let self = self else { return }
            let annotations = self.students.map { self.buildAnnotation(with: $0) }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    private func buildAnnotation(with student: Student) -> MKPointAnnotation {
        let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(student.firstName) \(student.lastName)"
        annotation.subtitle = student.mediaURL
        return annotation
    }
    
    func refreshData() {
        mapView.removeAnnotations(mapView.annotations)
        loadMapData()
    }
    
}

// MARK: - Extensions

extension MapViewController: MKMapViewDelegate {
    
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
    
}
