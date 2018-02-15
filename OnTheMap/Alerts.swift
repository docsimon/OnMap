//
//  Alerts.swift
//  OnTheMap
//
//  Created by doc on 27/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

func displayError(errorTitle: String, errorMsg: String?, presenting: @escaping (UIAlertController)->() ){
    let alert = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    
    DispatchQueue.main.async {
        presenting(alert)
    }
}

func displayUpdateOptions(optionTitle: String, action: @escaping ()->(), presenting: @escaping (UIAlertController)->() ){
    let alert = UIAlertController(title: optionTitle, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
    
    alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in action() }
    ))
    
    DispatchQueue.main.async {
        presenting(alert)
    }
}

