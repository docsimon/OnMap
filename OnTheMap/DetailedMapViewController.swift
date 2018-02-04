//
//  DetailedMapViewController.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit
import MapKit

class DetailedMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var linkedinUrl: UITextField!
    @IBOutlet weak var map: MKMapView!
    let regionRadius: CLLocationDistance = 100000
    var myLocation: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let geoDecoder = CLGeocoder()
        geoDecoder.geocodeAddressString(myLocation){ (location, error) in
            guard error == nil, let location = location, location.count > 0 else{
                return
            }
            if let coordinates = location[0].location {
                self.centerMapOnLocation(location: coordinates)
            }
        }

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: false)
    }
    @IBAction func submitLocation(_ sender: Any) {
        
    }
    
}
