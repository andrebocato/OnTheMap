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
    @IBOutlet private weak var confirmLocationButton: UIButton! {
        didSet {
            confirmLocationButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet private weak var locationTextField: UITextField! {
        didSet {
            locationTextField.delegate = self
        }
    }
    @IBOutlet private weak var linkTextField: UITextField! {
        didSet {
            linkTextField.delegate = self
        }
    }
    @IBOutlet private weak var emptyLocationLabel: UILabel!
    @IBOutlet private weak var emptyLinkLabel: UILabel!
    
    // MARK: - Properties
    
    private var latitude: Double?
    private var longitude: Double?
    
    // MARK: - IBActions
    
    @IBAction private func confirmLocationButtonDidReceiveTouchUpInside(_ sender: Any) {
        validateInputsFor(textFields: [locationTextField, linkTextField],
                            withErrorLabels: [emptyLocationLabel, emptyLinkLabel]) { [weak self] (isValid) in
                                guard let self = self else { return }
                                if isValid && (self.latitude, self.longitude) != (0, 0) {
                                    self.performSegue(withIdentifier: "ConfirmLocationSegue", sender: self)
                                } else {
                                    Alerthelper.showErrorAlert(inController: self, withMessage: "Invalid latitude or longitude values.")
                                }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAddress()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let submitLocationViewController = segue.destination as? SubmitLocationViewController, segue.destination is SubmitLocationViewController {
            
            guard let location = locationTextField.text,
                let link = linkTextField.text,
                let latitude = latitude,
                let longitude = longitude else { return }
            
            submitLocationViewController.location = location
            submitLocationViewController.link = link
            submitLocationViewController.latitude = latitude
            submitLocationViewController.longitude = longitude
            
        }
    }
    
    // MARK: - Helper Functions
    private func loadAddress() {
        
        guard let address = locationTextField.text else {
            Alerthelper.showErrorAlert(inController: self, withMessage: "Could not load Address.") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
            
            guard error == nil else {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Could not load Address.") { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            guard let location = placemarks?.first?.location else {
                Alerthelper.showErrorAlert(inController: self, withMessage: "No matching location found") { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
            
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
    
}

