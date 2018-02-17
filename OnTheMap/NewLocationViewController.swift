//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var studentPlace: UITextField!
    var objectId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        studentPlace.delegate = self
    }

    @IBAction func findLocation(_ sender: Any) {
        if checkLocation(location: studentPlace?.text){
        performSegue(withIdentifier: "detailedMap", sender: nil)
        }else{
            displayError(errorTitle: Constants.Errors.invalidLocation, errorMsg: Constants.Errors.invalidLocationMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? DetailedMapViewController, let place = studentPlace?.text {
            destVC.myLocation = place
            destVC.objectId = objectId
        }else{
            //TODO: display an error message here
            print("error")
        }
    }
    
    func checkLocation(location: String?) -> Bool{
        if let location = location {
            return !location.isEmpty
        }
        return false
    }
    
    deinit {
        print("NewLocationViewController dismissed")
    }
}

// TextField protocol implementation
extension NewLocationViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
