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
        
        /* commenting everything until it gets fixed...
 
        FunctionsHelper.checkForEmptyText(usernameTextField, emptyUsernameLabel)
        FunctionsHelper.checkForEmptyText(passwordTextField, emptyPasswordLabel)
        
        if (usernameTextField.text != "") && (passwordTextField.text != "") {
            // @TODO: Refactor: there should be a better way to do this
            _ = textFieldShouldReturn(usernameTextField)
            _ = textFieldShouldReturn(passwordTextField)
            
            let username = usernameTextField.text!, password = passwordTextField.text!
            
            // 'print' statements are only for testing and finding where the code breaks. will be removed after this part is working fine
            
            // POST session and get response.account.key as a response
            UdacityClient.postSessionRequest(with: username, password: password, success: { (postSessionResponse) in
                
                // store response value in 'userId' variable
                if let userId = postSessionResponse?.account.key {
                    print("userId = " + userId)
                    
                    // use 'userId' to GET from response
                    UdacityClient.getUserIdRequest(with: userId, success: { (getUserIdResponse) in
                        // request is failing, 'success' scope is not being executed
                        guard userId == getUserIdResponse?.user.key else {
                            print("userId != getUserIdResponse?.user.key")
                            return
                        }
                        
                        DispatchQueue.main.async { */
                            self.performSegue(withIdentifier: "CompleteLoginSegue", sender: self)
                        /*}
                    }, failure: { (optionalError) in
                        if let error = optionalError {
                            self.displayError(error, description: "Failed to GET userId.")
                        }
                    })
                    // end of GET userId request
                }
            }, failure: { (optionalError) in
                if let error = optionalError {
                    self.displayError(error, description: "Failed to POST login session.")
                }
            })
            // end of POST session request
        } */
    }
    
    @IBAction private func signUpButtonDidReceiveTouchUpInside(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        FunctionsHelper.configureButton(loginButton)
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
    
}

// MARK: - Extensions

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
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
