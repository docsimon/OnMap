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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
       // displaySession(id: sid)
        addBarButtons(vc: self)
        fetchStudentsLocation()
    }

//    func displaySession(id: String){
//    }
    
    @objc func pin(){
        performSegue(withIdentifier: "pinMap", sender: nil)
    }
    @objc func reload(){
    }
    
    func fetchStudentsLocation() {
        // build and check the url
        let url = buildUrl(baseUrl: Constants.parseBaseUrl, path: Constants.parseGetPath, query: nil)
        guard let murl = url else {
            print(Constants.Errors.urlTitle)
            displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // create the url POST request
        let request = buildRequest(url: murl, method: nil, body: nil, apis: true)
        
        // make the connection
        makeConnection(request: request, securityCheck: false, jsonHandler: parseGetStudentLocationJson, completion: {(data, error) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                displayError(errorTitle: Constants.Errors.clientTitle, errorMsg: error!.localizedDescription, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            
            guard let data = data else {
                print(Constants.Errors.dataTitle)
                displayError(errorTitle: Constants.Errors.dataTitle, errorMsg: Constants.Errors.dataMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Map", sender: nil)
            }
           
            
        })
        
    }
    
    deinit {
        print("deinit map")
    }
}
