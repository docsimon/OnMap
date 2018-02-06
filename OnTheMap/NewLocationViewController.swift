//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController {

    @IBOutlet weak var studentPlace: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func findLocation(_ sender: Any) {
       // dismiss(animated: false, completion: nil)
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
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("NewLocationViewController dismissed")
    }
}
