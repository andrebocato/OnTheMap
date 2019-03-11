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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMapData()
    }
    
    // @TODO: Refactor, repeated code
    private func loadMapData() {
        // GET request for students
        ParseClient.getStudentsRequest(limit: 100, skip: 100, order: "-updatedAt", success: { [weak self] (getStudentsResponse) in
            guard let students = getStudentsResponse?.results else { return }
            self?.createStudentsAnnotations(using: students)
            }, failure: { [weak self] (optionalError) in
                guard let self = self, let error = optionalError else { return }
                Alerthelper.showErrorAlert(inController: self, withMessage: "Failed to download students data.")
                self.logError(error, description: "Failed to GET students.")
        }) // end of GET students request
    }
    
    private func createStudentsAnnotations(using students: [Student]) {
        let annotations = students.map { (student) -> MKPointAnnotation in
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0, longitude: student.longitude ?? 0)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName ?? "") \(student.lastName ?? "")"
            annotation.subtitle = student.mediaURL
            return annotation
        }
        mapView.addAnnotations(annotations)
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
        guard let annotationSubtitle = view.annotation?.subtitle,
            let urlString = annotationSubtitle,
            let url = URL(string: urlString),
            control == view.rightCalloutAccessoryView else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - DataRefreshable protocol stubs
    
    func refreshData() {
        mapView.removeAnnotations(mapView.annotations)
        loadMapData()
    }
    
}
