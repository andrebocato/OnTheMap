//
//  ViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//
// @TODO: fix login
// @TODO: fix activityIndicatorView. it doesn't stop its animation or gets hidden!!!

import Foundation
import UIKit

class LoginViewController: UIViewController {
        
    // MARK: - IBOutlets
    
    @IBOutlet private weak var udacityLogoImageView: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var noAccountLabel: UILabel!
    @IBOutlet private weak var emptyUsernameLabel: UILabel!
    @IBOutlet private weak var emptyPasswordLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - IBActions
    
    @IBAction private func loginButtonDidReceiveTouchUpInside(_ sender: Any) {
 
        FunctionsHelper.checkForEmptyText(usernameTextField, emptyUsernameLabel)
        FunctionsHelper.checkForEmptyText(passwordTextField, emptyPasswordLabel)
        
        if (usernameTextField.text != "") && (passwordTextField.text != "") {
            // @TODO: Refactor: there should be a better way to do this
            _ = textFieldShouldReturn(usernameTextField)
            _ = textFieldShouldReturn(passwordTextField)
            
            self.doLogin()
        }
    }
    
    @IBAction private func signUpButtonDidReceiveTouchUpInside(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        FunctionsHelper.configureButton(loginButton)
    }
    
    // MARK: - Helper Functions
    
    private func doLogin() {
        self.configureUIForRequestInProgress(true)
        
        let username = usernameTextField.text!, password = passwordTextField.text!
        
        UdacityClient.postSessionRequest(with: username, password: password, success: { (postSessionResponse) in
            
            if let userId = postSessionResponse?.account?.key {
                UdacityClient.getUserRequest(with: userId, success: { (userFromResponse) in
                    CurrentSessionData.shared.user = userFromResponse
                    DispatchQueue.main.async {
                        self.configureUIForRequestInProgress(false)
                        
                        self.performSegue(withIdentifier: "CompleteLoginSegue", sender: self)
                    }
                }, failure: { (optionalError) in
                    // repeated code
                    if let error = optionalError {
                        self.displayError(error, description: "Failed to GET userId.")
                    }
                    self.configureUIForRequestInProgress(false)
                })
                // end of GET userId request
            }
        }, failure: { (optionalError) in
            // repeated code
            if let error = optionalError {
                self.displayError(error, description: "Failed to POST login session.")
            }
            self.configureUIForRequestInProgress(false)
        })
        // end of POST session request
    }
    
    // repeated code
    private func displayError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError:\n\(error)")
        } else {
            print("An unknown error occurred. Error:\n\(error)")
        }
    }
    
    // @TODO: refactor. could be better
    private func configureUIForRequestInProgress(_ inProgress: Bool) {
        if inProgress == true {
            activityIndicatorView.startAnimating()
            activityIndicatorView.isHidden = false
            loginButton.isEnabled = false
        } else {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
            loginButton.isEnabled = true
        }
    }
    
}

// MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            // @TODO: press login button
            print("login button must be pressed")
        default: return true
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        passwordTextField.isSecureTextEntry = true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // @TODO: refactor. there must be a better way to do this
        switch textField {
        case usernameTextField:
            if let label = emptyUsernameLabel {
                FunctionsHelper.checkForEmptyText(textField, label)
            }
        case passwordTextField:
            if let label = emptyPasswordLabel {
                FunctionsHelper.checkForEmptyText(textField, label)
            }
        default: return
        }
    }
    
}
