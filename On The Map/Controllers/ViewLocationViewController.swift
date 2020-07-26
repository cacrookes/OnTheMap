//
//  ViewLocationViewController.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-25.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import MapKit

class ViewLocationViewController: UIViewController {

    var coordinates: CLLocationCoordinate2D?
    var pinTitle: String?
    var mediaURL: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
                
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        // Hardcoding first name and last name due to issues with the Udacity API:
        // https://knowledge.udacity.com/questions/260011
        let postLocation = PostLocationRequest(uniqueKey: OTMClient.Auth.userId,
                                               firstName: "MIYAVI",
                                               lastName: "Ishihara",
                                               mapString: pinTitle!,
                                               mediaURL: mediaURL!,
                                               latitude: coordinates!.latitude,
                                               longitude: coordinates!.longitude)
        _ = OTMClient.postStudentLocation(studentLocation: postLocation, completion: handlePostLocationResponse(success:error:))
    }
    
    func setupMap(){
        let location = MKPointAnnotation()
        guard let coordinates = self.coordinates else {
            return
        }
        location.coordinate = coordinates
        location.title = self.pinTitle
        self.mapView.addAnnotation(location)
        
        // center map around pin, based on code found here:
        // https://stackoverflow.com/a/41640054
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinates,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?){
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            // TODO: Handle error
            print(error!)
        }
    }
    
}
