//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-24.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateMap()
    }
    
    // MARK: - IBActions
    @IBAction func refreshClicked(_ sender: Any) {
        populateMap()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        _ = OTMClient.logout(completion: { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(message: "Unable to logout.")
            }
        })
    }
    
    // MARK: - Helper functions
    /// Get the 100 most recent student locations and add pins for each student on the map.
    func populateMap(){
        // load 100 most recent students in studentList array
        OTMClient.getStudentList(numStudents: 100) { (students, error) in
            if error != nil {
                self.showAlert(message: "Unable to download student locations. Please try again later.")
            } else {
                StudentModel.studentList = students
                
                // transform the list of students returned by API to array of StudentLocations,
                // which conforms to MKAnnotation Protocol
                let studentLocations = StudentModel.studentList.map() {StudentLocation(student: $0)}
                self.mapView.addAnnotations(studentLocations)
            }
        }
    }

    /// Show an alert to the user
    ///
    /// - Parameter message: The message to display to the user in the alert.
    func showAlert(message: String){
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // make sure annotation conforms to custom type StudentLocation
        guard annotation is StudentLocation else { return nil }
        
        let reuseIdentifier = "studentLocation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
    
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .blue
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = URL(string: (view.annotation?.subtitle)!!) {
                UIApplication.shared.open(mediaURL)
            }
        }
    }
}
