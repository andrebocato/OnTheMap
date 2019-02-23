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
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    // @TODO: implement everything
    
}

// MARK: - Extensions

extension MapViewController: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    
    
}
