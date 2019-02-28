//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var personLocationImageView: UIImageView!
    @IBOutlet private weak var confirmLocationButton: UIButton!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var linkTextField: UITextField!
    @IBOutlet private weak var emptyLocationLabel: UILabel!
    @IBOutlet private weak var emptyLinkLabel: UILabel!
    
    // MARK: - Properties
    
    var latitude = Double()
    var longitude = Double()
    
    // MARK: - IBActions

    @IBAction private func confirmLocationButtonDidReceiveTouchUpInside(_ sender: Any) {
        FunctionsHelper.checkForEmptyText(locationTextField, emptyLocationLabel)
        FunctionsHelper.checkForEmptyText(linkTextField, emptyLinkLabel)
        
        if (locationTextField.text != "") && (linkTextField.text != "") {
            // @TODO: check if response was ok
            performSegue(withIdentifier: "ConfirmLocationSegue", sender: self)
        }
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        linkTextField.delegate = self
        
        if let address = locationTextField.text {
            CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
        
        // refactor: create new button type
        confirmLocationButton.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SubmitLocationViewController {
            if let submitLocationViewController = segue.destination as? SubmitLocationViewController {
                submitLocationViewController.location = locationTextField.text!
                submitLocationViewController.link = linkTextField.text!
                submitLocationViewController.latitude = latitude
                submitLocationViewController.longitude = longitude
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?,
                                 error: Error?) {
        
        if let error = error {
            print("Unable to Forward Geocode Address. \n\(error)")
            // @TODO: send alert "Unable to find location address"
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
            } else {
                // @TODO: send alert "No matching location found"
            }
        }
    }
    
}

// MARK: - Extensions

extension InformationPostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField == locationTextField {
            linkTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // @TODO: refactor. there must be a better way to do this
        switch textField {
        case locationTextField:
            if let label = emptyLocationLabel {
                FunctionsHelper.checkForEmptyText(textField, label)
            }
        case linkTextField:
            if let label = emptyLinkLabel {
                FunctionsHelper.checkForEmptyText(textField, label)
            }
        default: return
        }
    }
    
}

