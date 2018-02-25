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
    var students: [[String:Any]] = []
    var objectId: String?
    private var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        if let coordinates = coordinates {
            setMapCenter(coordinates)
        }
    }

    @objc func pin(){
        
        if let objectId_ = updatePosition(studentArray: SharedData.shared.studentsInformations as? [StudentInformation]) {
            // display the alert
            objectId = objectId_
            displayUpdateOptions(optionTitle: "Do you vant to update your position?", action: updateLocation, presenting:{alert in
                self.present(alert, animated: true)
            })
        }else {
            updateLocation()
        }
    }
    @objc func logout(){
        sessionLogout(completion: validateSessionLogout, sender: self)
    }
    
    func validateSessionLogout(data: Codable?){
        if let _ = (data as? DeleteResponse)?.session {
            appDelegate.userLoginData = nil
            DispatchQueue.main.async {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }else{
            displayError(errorTitle: Constants.Errors.userSessionStatus, errorMsg: Constants.Errors.userSessionStatus, presenting: { alert in
                self.present(alert, animated: true)
            })
        }
    }
    
    func addAnnotationsToMap(locations: [StudentInformation?]){
        SharedData.shared.studentsInformations = locations
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            let annotation = MKPointAnnotation()
            guard let lat = dictionary?.latitude, let long = dictionary?.longitude  else {
                continue
            }
            let latitude = CLLocationDegrees(lat)
            let longitude = CLLocationDegrees(long)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.coordinate = coordinate
            
            if let first = dictionary?.firstName, let last  = dictionary?.lastName {
                annotation.title = "\(first) \(last)"
            }
            
            if let mediaURL = dictionary?.mediaURL{
                annotation.subtitle = mediaURL
            }
            annotations.append(annotation)
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    private func setMapCenter(_ coordinates: CLLocationCoordinate2D){
        self.mapView.setCenter(coordinates, animated: true)
    }
    
    func setCoordinates(coordinates: CLLocationCoordinate2D){
        self.coordinates = coordinates
    }
    
    func updateLocation(){
        performSegue(withIdentifier: "pinMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? NewLocationViewController {
            destVC.objectId = objectId
        }
    }
    
    func resetMap(){
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func fetchData(){
        resetMap()
        students.removeAll()
        fetchStudentsLocation(completion: addAnnotationsToMap, sender: self)
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
