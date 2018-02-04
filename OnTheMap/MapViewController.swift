//
//  MapViewController.swift
//  OnTheMap
//
//  Created by doc on 29/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, SetupNavBarButtons {
    @IBOutlet weak var mapView: MKMapView!
    var sid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySession(id: sid)
        addBarButtons(vc: self)
    }

    func displaySession(id: String){
    }
    
    @objc func pin(){
        performSegue(withIdentifier: "pinMap", sender: nil)
    }
    @objc func reload(){
    }
    
    deinit {
        print("deinit map")
    }
}
