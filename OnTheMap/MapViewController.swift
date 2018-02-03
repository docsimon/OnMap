//
//  MapViewController.swift
//  OnTheMap
//
//  Created by doc on 29/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, SetupNavigationBarWithButtons {
    @IBOutlet weak var mapView: MKMapView!
    var sid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySession(id: sid)
        //navigationController?.navigationBar.topItem?.title = "Simone"
        
        addBarButtons(pinSelector: #selector(pin), refreshSelector: #selector(reload),navigationItem: navigationItem)
    }

    func displaySession(id: String){
    }
    
    @objc func pin(){
        print("cippa pin")
    }
    @objc func reload(){
        print("cippa refresh")
    }
    
    deinit {
        print("deinit map")
    }
}
