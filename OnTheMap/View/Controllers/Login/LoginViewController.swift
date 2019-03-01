//
//  ViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

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
        validateEmptyInputs(textFields: [usernameTextField, passwordTextField], errorLabels: [emptyUsernameLabel, emptyPasswordLabel]) { (true) in
            doLogin()
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
        
        // refactor: create new button type
        loginButton.layer.cornerRadius = 15
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    // MARK: - Helper Functions
    
    private func doLogin() {
        configureUIForRequestInProgress(true)
        
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        UdacityClient.postSessionRequest(withUsername: username, password: password, success: { (postSessionResponse) in
            
            if let userId = postSessionResponse?.account?.key {
                UdacityClient.getUserRequest(withId: userId, success: { (userFromResponse) in
                    CurrentSessionData.shared.user = userFromResponse
                    DispatchQueue.main.async {
                        self.configureUIForRequestInProgress(false)
                        self.performSegue(withIdentifier: "CompleteLoginSegue", sender: self)
                    }
                }, failure: { (optionalError) in
                    if let error = optionalError {
                        Alerthelper.showErrorAlert(inController: self, withMessage: "Login failed.")
                        self.displayError(error, description: "Failed to GET userId.")
                    }
                    self.configureUIForRequestInProgress(false)
                })
                // end of GET userId request
            }
        }, failure: { (optionalError) in
            if let error = optionalError {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Login failed.")
                self.displayError(error, description: "Failed to POST login session.")
            }
            self.configureUIForRequestInProgress(false)
        })
        // end of POST session request
    }
    
    // @TODO: Refactor, repeated code
    private func displayError(_ error: Error,
                              description: String? = nil) {
        
        if let description = description {
            print(description + "\nError: \(error)")
        } else {
            print("An unknown error occurred. Error: \(error)")
        }
    }
    
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else { // textField == passwordTextField
            if textField.text != "" {
                doLogin()
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        passwordTextField.isSecureTextEntry = true
        return true
    }
    
}
