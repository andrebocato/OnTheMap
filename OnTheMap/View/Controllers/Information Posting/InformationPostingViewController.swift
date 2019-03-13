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
    @IBOutlet private weak var findLocationButton: UIButton! {
        didSet {
            findLocationButton.layer.cornerRadius = 15
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
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func findLocationButtonDidReceiveTouchUpInside(_ sender: Any) {
        
        view.configureUIForLoading(true, activityIndicatorView, findLocationButton)
        
        let areTextFieldInputsValid = locationTextField.hasValidInput() && linkTextField.hasValidInput()
        
        if !areTextFieldInputsValid {
            
            if !locationTextField.hasValidInput() {
                emptyLocationLabel.text  = "This field must not be empty."
            }
            
            if !linkTextField.hasValidInput() {
                emptyLinkLabel.text  = "This field must not be empty."
            }
            
            view.configureUIForLoading(false, self.activityIndicatorView, self.findLocationButton)
            Alerthelper.showErrorAlert(inController: self, withMessage: "Could not find location.")
            
            return
        }
        
        loadAddress(onSuccess: { (location) in
            self.view.configureUIForLoading(false, self.activityIndicatorView, self.findLocationButton)
            self.performSegue(withIdentifier: "ConfirmLocationSegue", sender: location)
        })
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let submitLocationViewController = segue.destination as? SubmitLocationViewController, segue.destination is SubmitLocationViewController {
            
            guard let location = locationTextField.text,
                let link = linkTextField.text,
                let latitude =  (sender as? CLLocation)?.coordinate.latitude,
                let longitude = (sender as? CLLocation)?.coordinate.longitude else { return }
            
            submitLocationViewController.location = location
            submitLocationViewController.link = link
            submitLocationViewController.latitude = latitude
            submitLocationViewController.longitude = longitude
            
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadAddress(onSuccess: @escaping (_ coordinate: CLLocation) -> Void) {
        
        guard let address = locationTextField.text else {
            view.configureUIForLoading(false, activityIndicatorView, findLocationButton)
            Alerthelper.showErrorAlert(inController: self, withMessage: "Could not load Address.") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            self.view.configureUIForLoading(true, self.activityIndicatorView, self.findLocationButton)
            
            guard error == nil else {
                self.view.configureUIForLoading(false, self.activityIndicatorView, self.findLocationButton)
                Alerthelper.showErrorAlert(inController: self, withMessage: "Could not load Address.") { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            guard let location = placemarks?.first?.location else {
                self.view.configureUIForLoading(false, self.activityIndicatorView, self.findLocationButton)
                Alerthelper.showErrorAlert(inController: self, withMessage: "No matching location found") { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            self.view.configureUIForLoading(false, self.activityIndicatorView, self.findLocationButton)
            onSuccess(location)
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
