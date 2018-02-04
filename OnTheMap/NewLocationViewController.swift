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
        performSegue(withIdentifier: "detailedMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? DetailedMapViewController, let place = studentPlace?.text {
            destVC.myLocation = place
        }else{
            //TODO: display an error message here
            print("error")
        }
    }
    
    deinit {
        print("NewLocationViewController dismissed")
    }
}
