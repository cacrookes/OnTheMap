//
//  EnterLocationViewController.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-25.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class EnterLocationViewController: UIViewController {

    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func findLocationClicked(_ sender: Any) {
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
}
