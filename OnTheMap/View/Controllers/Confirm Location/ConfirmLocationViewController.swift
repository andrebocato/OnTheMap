//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by André Sanches Bocato on 13/02/19.
//  Copyright © 2019 André Sanches Bocato. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapItem!
    @IBOutlet private weak var finishButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction private func finishButtonDidReceiveTouchUpInside(_ sender: Any) {
        // @TODO: POST data
        // @TODO: dismiss view and pop back to tab bar view
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FunctionsHelper.configureButton(finishButton)
    }
    
}
