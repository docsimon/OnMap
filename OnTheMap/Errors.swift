//
//  Errors.swift
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


