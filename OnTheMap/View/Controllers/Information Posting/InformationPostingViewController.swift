//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit

class InformationPostingViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var personLocationImageView: UIImageView!
    @IBOutlet private weak var confirmLocationButton: UIButton!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var linkTextField: UITextField!
    @IBOutlet private weak var emptyLocationLabel: UILabel!
    @IBOutlet private weak var emptyLinkLabel: UILabel!
    
    // MARK: - IBActions

    @IBAction private func confirmLocationButtonDidReceiveTouchUpInside(_ sender: Any) {
        // @TODO: search location in map database
       
        FunctionsHelper.checkForEmptyText(locationTextField, emptyLocationLabel)
        FunctionsHelper.checkForEmptyText(linkTextField, emptyLinkLabel)
        
        if (locationTextField.text != "") && (linkTextField.text != "") {
            performSegue(withIdentifier: "ConfirmLocationSegue", sender: self)
        }
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        linkTextField.delegate = self
        FunctionsHelper.configureButton(confirmLocationButton)
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

