//
//  OnTheMapTabBarControllerViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//
// @TODO: inform user if download fails
// @TODO: show downloaded data in mapview and tableview. actually returning empty arrays

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - IBActions
    
    @IBAction private func logoutBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        // DELETE request
        UdacityClient.deleteSesionRequest(success: { [weak self] _ in
            CurrentSessionData.shared.clearSessionData()
            self?.selectedViewController?.dismiss(animated: true, completion: nil)
            }, failure: { [weak self] (optionalError) in
                guard let self = self else { return }
                if let error = optionalError {
                    DispatchQueue.main.async {
                        Alerthelper.showErrorAlert(inController: self, withMessage: "Logout failed.")
                    }
                    self.logError(error, description: "Logout request failed.")
                }
        }) // end of DELETE request
    }
    
    @IBAction private func refreshBarButtonDidReceiveTouchUpInside(_ sender: Any) {
        (selectedViewController as? DataRefreshable)?.refreshData()
    }
    
}
