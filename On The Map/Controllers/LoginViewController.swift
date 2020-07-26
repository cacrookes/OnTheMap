//
//  ViewController.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-23.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginPressed(_ sender: Any) {
        let username: String = emailTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        _ = OTMClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
    }
    
    
    @IBAction func signupPressed(_ sender: Any) {
        // redirect the user to the sign up page on Udacity's website.
        if let signupURL = URL(string: K.udacitySignUpURL) {
            UIApplication.shared.open(signupURL)
        }
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
        emailTextField.isEnabled = !isBusy
        passwordTextField.isEnabled = !isBusy
        loginButton.isEnabled = !isBusy
        signupButton.isEnabled = !isBusy
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setIsBusy(false)
        if success {
            performSegue(withIdentifier: K.identifiers.completeLoginSegue, sender: nil)
        } else {
            // TODO: handle error
            //showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
}

