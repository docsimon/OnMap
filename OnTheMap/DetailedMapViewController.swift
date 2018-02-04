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
    @IBOutlet weak var mediaUrl: UITextField!
    @IBOutlet weak var map: MKMapView!
    let regionRadius: CLLocationDistance = 100000
    var myLocation: String = ""
    var coordinates: CLPlacemark? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationOnMap()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: false)
    }
    @IBAction func submitLocation(_ sender: Any) {
        postStudentLocation(mediaUrl?.text, locationData: coordinates)
    }
    
    private func postStudentLocation(_ mediaURL: String?, locationData: CLPlacemark?){
        
        // Check if I have the uniqueKey
//        guard let uniqueKey = appDelegate.userLoginData?.userKey else {
//            displayError(errorTitle: Constants.Errors.unauthorizedAccess, errorMsg: Constants.Errors.wrongUserKey, presenting: {alert in
//                self.present(alert, animated: true)
//            })
//            return
//        }
       let uniqueKey = "1234"
        
        // check mediaURL
        guard let media = mediaURL, let _ = URLComponents(string: media) else {
            print("Invalid url: ", mediaURL ?? "Unknown")
            displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // build and check the url
        let url = buildUrl(baseUrl: Constants.parseBaseUrl, path: Constants.parsePostPath, query: nil)
        guard let murl = url else {
            print(Constants.Errors.urlTitle)
            displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        
        // check location
        guard let latitude = coordinates?.location?.coordinate.latitude,
            let longitude = coordinates?.location?.coordinate.latitude else {
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
        
        
        print(studentPlace," ", latitude," ", longitude)
        
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
        
        // create the url POST request
//        let request = buildRequest(url: murl, method: "POST", body: body)
//        makeConnection(request: request, jsonHandler: parseAuthJson, completion: {(data, error) in
//
//            guard (error == nil) else {
//                print(error!.localizedDescription)
//                displayError(errorTitle: Constants.Errors.clientTitle, errorMsg: error!.localizedDescription, presenting: { alert in
//                    self.present(alert, animated: true)
//                })
//                return
//            }
//
//            guard let data = data else {
//                print(Constants.Errors.dataTitle)
//                displayError(errorTitle: Constants.Errors.dataTitle, errorMsg: Constants.Errors.dataMsg, presenting: { alert in
//                    self.present(alert, animated: true)
//                })
//                return
//            }
//            if let key = data["key"] as? String, let session = data["sessionId"] as? String {
//                self.userLoginData = UserLoginData(userKey:key, userSession: session)
//                //print(userLoginData.userKey, " ", userLoginData.userSession)
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "Map", sender: nil)
//                }
//            }else {
//                print(Constants.Errors.dataTitle)
//                displayError(errorTitle: Constants.Errors.loginUnknownErrorTitle, errorMsg: Constants.Errors.loginUnknownErrorMsg, presenting: { alert in
//                    self.present(alert, animated: true)
//                })
//                return
//            }
//
//        })
        
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
            }
        }
    }
    
    @IBAction func dismissMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Detailed dismissed")
    }
}
