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
    private var coordinates: CLLocationCoordinate2D?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons(vc: self)
        fetchStudentsLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coordinates = coordinates {
            setMapCenter(coordinates)

        }
    }

    @objc func pin(){
        performSegue(withIdentifier: "pinMap", sender: nil)
    }
    @objc func reload(){
        fetchStudentsLocation()
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
            
            if let studentArray = data["results"] as? [[String:Any]] {
                self.appDelegate.studentsLocation = studentArray
                self.addAnnotationsToMap(locations: studentArray)
                //mapView.setCenter(CLLocationCoordinate2D, animated: true)
            }else {
                displayError(errorTitle: Constants.Errors.noStudentLocations, errorMsg: Constants.Errors.noStudentLocationsMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
            }
           
        })
    }
    
    func addAnnotationsToMap(locations: [[String:Any]]){
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            let annotation = MKPointAnnotation()
            guard let lat = dictionary["latitude"] as? Double, let long = dictionary["longitude"] as? Double  else {
                continue
            }
            let latitude = CLLocationDegrees(lat)
            let longitude = CLLocationDegrees(long)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.coordinate = coordinate
            
            if let first = dictionary["firstName"] as? String, let last  = dictionary["lastName"] as? String {
                annotation.title = "\(first) \(last)"
            }
            
            if let mediaURL = dictionary["mediaURL"] as? String {
                annotation.subtitle = mediaURL
            }
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    private func setMapCenter(_ coordinates: CLLocationCoordinate2D){
        self.mapView.setCenter(coordinates, animated: true)
    }
    
    func setCoordinates(coordinates: CLLocationCoordinate2D){
        self.coordinates = coordinates
    }
    
    deinit {
        print("deinit map")
    }
}
// Implement Map delegate methods
extension MapViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let subtitle = view.annotation?.subtitle, let toOpen = subtitle, let url = URL(string: toOpen) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
