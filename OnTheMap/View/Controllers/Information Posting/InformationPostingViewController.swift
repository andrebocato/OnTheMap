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
    
    private var latitude = Double()
    private var longitude = Double()
    
    // MARK: - IBActions
    
    @IBAction private func confirmLocationButtonDidReceiveTouchUpInside(_ sender: Any) {
        validateEmptyInputs(textFields: [locationTextField, linkTextField], errorLabels: [emptyLocationLabel, emptyLinkLabel]) { (true) in
            if (self.latitude, self.longitude) != (0, 0) {
                self.performSegue(withIdentifier: "ConfirmLocationSegue", sender: self)
            } else {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Invalid latitude or longitude values.")
            }
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
            Alerthelper.showErrorAlert(inController: self, withMessage: "Unable to forward Geocode Address.")
            debugPrint("ERROR: \(error)")
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
    
    // @TODO: Refactor, repeated code
    private func isValidInput(_ textField: UITextField) -> Bool {
        guard let input = textField.text, !input.isEmpty else {
            return false
        }
        return true
    }
    
    // @TODO: Refactor, repeated code
    private func validateEmptyInputs(textFields: [UITextField],
                             errorLabels: [UILabel],
                             completion: ((Bool) -> Void)) {
        guard !(textFields.count == errorLabels.count) else { return }
        
        var validFields = 0
        for i in 0...textFields.count {
            if !isValidInput(textFields[i]) {
                errorLabels[i].text = "This field must not be empty."
            } else {
                validFields += 1
            }
        }
        
        completion(validFields == textFields.count)
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
    
}

