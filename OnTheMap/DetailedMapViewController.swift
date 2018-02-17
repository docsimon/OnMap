//
//  DetailedMapViewController.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit
import MapKit

class DetailedMapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var mediaUrl: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100000
    var myLocation: String = ""
    var coordinates: CLPlacemark? = nil
    var objectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaUrl.delegate = self
        findLocationOnMap()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func setAnnotation(location: CLLocation){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "\(Constants.UserPersonalData.firstName) \(Constants.UserPersonalData.lastName)"
        self.mapView.addAnnotations([annotation])

    }
    @IBAction func submitLocation(_ sender: Any) {
        postStudentLocation(mediaUrl?.text, locationData: coordinates)
    }
    
    private func postStudentLocation(_ mediaURL: String?, locationData: CLPlacemark?){
        
        // Check if I have the uniqueKey
        guard let uniqueKey = appDelegate.userLoginData?.userKey else {
            displayError(errorTitle: Constants.Errors.unauthorizedAccess, errorMsg: Constants.Errors.wrongUserKey, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        // check mediaURL
        guard let media = mediaURL, let _ = URLComponents(string: media.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            print("Invalid url: ", mediaURL ?? "Unknown")
            displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // build and check the url
        
        let path = "\(Constants.parsePath)/\(objectId ?? "")"
        let url = buildUrl(baseUrl: Constants.parseBaseUrl, path: path, query: nil)
        guard let murl = url else {
            print(Constants.Errors.urlTitle)
            displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // check location
        guard let latitude = coordinates?.location?.coordinate.latitude,
            let longitude = coordinates?.location?.coordinate.longitude else {
                displayError(errorTitle: Constants.Errors.invalidLocation, errorMsg:Constants.Errors.invalidLocationMsg , presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
        }
        
        // create the POST body
        var studentPlace: String {
            return (coordinates?.locality ?? myLocation) + " " +
                   (coordinates?.country ?? "Unknown")
        }
                
        let postBody = StudentLocation(
            uniqueKey: uniqueKey,
            firstName: Constants.UserPersonalData.firstName,
            lastName: Constants.UserPersonalData.lastName,
            mapString: studentPlace,
            mediaURL: media,
            latitude: latitude,
            longitude: longitude )
        
        guard let body = makeBody(bodyStructure: postBody) else {
            print("Body is empty ")
            displayError(errorTitle: Constants.Errors.encodingBodyTitle, errorMsg:Constants.Errors.encodingBodyMsg , presenting: { alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // create the url request
        let method = objectId != nil ? "PUT" : "POST"
        let handler = objectId != nil ? parsePutStudentLocationJson : parsePostStudentLocationJson
        let request = buildRequest(url: murl, method: method, body: body, apis: true)
        makeConnection(request: request, securityCheck: false, jsonHandler: handler, completion: {(data, error) in

            let errorMsg = error?.localizedDescription ?? "No description"
            guard (error == nil) else {
                print(errorMsg)
                displayError(errorTitle: Constants.Errors.errorPostingStudentLocation, errorMsg: errorMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            guard data != nil else {
                displayError(errorTitle: Constants.Errors.errorPostingStudentLocation, errorMsg: errorMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            DispatchQueue.main.async {
                if let tabBarVC = self.getTabBarVC() {
                    self.navigationController?.popToViewController(tabBarVC, animated: false)
                    }
            }
        })
        
    }
    
    func findLocationOnMap(){
        
        let geoDecoder = CLGeocoder()
        geoDecoder.geocodeAddressString(myLocation){ (location, error) in
            guard error == nil, let location = location, location.count > 0 else{
                return
            }
            
            self.coordinates = location[0]
            
            if let coordinate = self.coordinates?.location {
                self.centerMapOnLocation(location: coordinate)
                self.setAnnotation(location: coordinate)
            }
        }
    }
    
    func getTabBarVC() -> UIViewController? {
        let tabBarVC = navigationController?.viewControllers[0]
        return tabBarVC
    }
    
    deinit {
        print("Detailed dismissed")
    }
}

// TextField protocol implementation
extension DetailedMapViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension DetailedMapViewController {
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
}
