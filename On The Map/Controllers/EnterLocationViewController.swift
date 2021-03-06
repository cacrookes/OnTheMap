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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        setIsBusy(true)
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            self.setIsBusy(false)
            if error != nil {
                self.showAlert(message: "Could not find location", firstResponder: self.locationTextField)
                return
            }
            guard let coordinates = placemarks?.first?.location?.coordinate else {
                self.showAlert(message: "Unable to extract location information", firstResponder: self.locationTextField)
                return
            }
            // pass values to the ViewLocation controller to display location on a map.
            let controller = self.storyboard?.instantiateViewController(identifier: K.identifiers.viewLocationViewController) as! ViewLocationViewController
            
            controller.coordinates = coordinates
            controller.mediaURL = mediaURL
            controller.pinTitle = placemarks?.first?.name ?? ""
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Sets the app to busy mode. Enables activityIndicator and disables buttons and text fields
    ///
    /// - Parameter isBusy: a boolean indicating if the app is busy or not.
    func setIsBusy(_ isBusy: Bool) {
        if isBusy {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        locationTextField.isEnabled = !isBusy
        mediaURLTextField.isEnabled = !isBusy
        findLocationButton.isEnabled = !isBusy
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
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
