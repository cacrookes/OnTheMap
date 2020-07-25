//
//  StudentLocation.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-24.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

import MapKit
import UIKit

// this code was inspired by: https://www.hackingwithswift.com/read/16/2/up-and-running-with-mapkit
class StudentLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    // Create a generic initializer
    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
    
    // Initialize an instance of this class using a StudentInformation instance
    init(student: StudentInformation) {
        let title = "\(student.firstName) \(student.lastName)"
        let lat = CLLocationDegrees(student.latitude)
        let long = CLLocationDegrees(student.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        self.title = title
        self.coordinate = coordinate
        self.subtitle = student.mediaURL
    }
}
