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
    @IBOutlet private weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
        }
    }
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.delegate = self
        }
    }
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 15
        }
    }
    @IBOutlet private weak var noAccountLabel: UILabel!
    @IBOutlet private weak var emptyUsernameLabel: UILabel!
    @IBOutlet private weak var emptyPasswordLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func loginButtonDidReceiveTouchUpInside(_ sender: Any) {
        validateInputsFor(textFields: [usernameTextField, passwordTextField], withErrorLabels: [emptyUsernameLabel, emptyPasswordLabel]) { [weak self] (isValid) in
            if isValid { self?.doLogin() }
        }
    }
    
    @IBAction private func signUpButtonDidReceiveTouchUpInside(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: - Helper Functions
    
    private func doLogin() {
        configureUIForRequestInProgress(true)
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        UdacityClient.postSessionRequest(withUsername: username, password: password, success: { (postSessionResponse) in
            guard let userID = postSessionResponse?.account?.key else { return }
            UdacityClient.getUserRequest(withId: userID, success: { [weak self] (userFromResponse) in
                CurrentSessionData.shared.user = userFromResponse
                DispatchQueue.main.async {
                    self?.configureUIForRequestInProgress(false)
                    self?.performSegue(withIdentifier: "CompleteLoginSegue", sender: self)
                }
            }, failure: { [weak self] (optionalError) in
                guard let self = self else { return }
                if let error = optionalError {
                    Alerthelper.showErrorAlert(inController: self, withMessage: "Login failed.")
                    self.logError(error, description: "Failed to GET userId.")
                }
                self.configureUIForRequestInProgress(false)
            })
        }, failure: { [weak self] (optionalError) in
            guard let self = self else { return }
            if let error = optionalError {
                Alerthelper.showErrorAlert(inController: self, withMessage: "Login failed.")
                self.logError(error, description: "Failed to POST login session.")
            }
            self.configureUIForRequestInProgress(false)
        })
        // end of POST session request
    }
    
    private func configureUIForRequestInProgress(_ inProgress: Bool) {
        inProgress ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = !inProgress
        loginButton.isEnabled = inProgress
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
    
}
