//
//  EnterLocationViewController.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-25.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreLocation

class EnterLocationViewController: UIViewController {

    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func findLocationClicked(_ sender: Any) {
        let mediaURL = mediaURLTextField.text ?? ""
        let location = locationTextField.text ?? ""
        
        if location == "" {
            self.showAlert(message: "Please enter your location.", firstResponder: locationTextField)
            return
        }
        if mediaURL == "" {
            self.showAlert(message: "Please enter your site link.", firstResponder: mediaURLTextField)
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error != nil {
                self.showAlert(message: "Could not find location", firstResponder: self.locationTextField)
                return
            }
            guard let coordinates = placemarks?.first?.location?.coordinate else {
                self.showAlert(message: "Unable to extract location information", firstResponder: self.locationTextField)
                return
            }
            
        }
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Show an alert to the user
    ///
    /// - Parameters:
    ///   - message: The message to display to the user in the alert.
    ///   - firstResponder: The textfield that should receive the focus after the alert is closed.
    func showAlert(message: String, firstResponder: UITextField){
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            firstResponder.becomeFirstResponder()
        }))
        show(alertVC, sender: nil)
    }
    
    
}
