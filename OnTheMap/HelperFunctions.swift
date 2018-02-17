//
//  elperFunctions.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

typealias OptionalCompletion = ([[String:Any]])->()

let appDelegate = UIApplication.shared.delegate as! AppDelegate

func updatePosition(studentArray: [[String:Any]]) -> String?{
    guard let userKey = appDelegate.userLoginData?.userKey else {
        print("No user key")
        return nil
    }
    let userData = studentArray.filter { student in
        if let studentId = student["uniqueKey"] as? String, studentId == userKey{
            return true
        }
        return false
    }
    
    // userData should be 1
    if userData.count > 0 {
        if let objectId = userData[0]["objectId"] as? String {
            // call the alert
            return objectId
        }
    }
    return nil
}

func fetchStudentsLocation(completion: @escaping OptionalCompletion, sender: UIViewController) {
    
    // build and check the url
    let url = buildUrl(baseUrl: Constants.parseBaseUrl, path: Constants.parsePath, query: nil)
    guard let murl = url else {
        print(Constants.Errors.urlTitle)
        displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
            sender.present(alert, animated: true)
        })
        return
    }
    
    // create the url POST request
    let request = buildRequest(url: murl, method: nil, body: nil, apis: true)
    
    // make the connection
    makeConnection(request: request, securityCheck: false, jsonHandler: parseGetStudentLocationJson, completion: { (data, error) in
        
        guard (error == nil) else {
            print(error!.localizedDescription)
            displayError(errorTitle: Constants.Errors.clientTitle, errorMsg: error!.localizedDescription, presenting: { alert in
                sender.present(alert, animated: true)
            })
            return
        }
        
        guard let data = data else {
            print(Constants.Errors.dataTitle)
            displayError(errorTitle: Constants.Errors.dataTitle, errorMsg: Constants.Errors.dataMsg, presenting: { alert in
                sender.present(alert, animated: true)
            })
            return
        }
        
        if let studentArray = data["results"] as? [[String:Any]] {
            completion(studentArray)
        }else {
            displayError(errorTitle: Constants.Errors.noStudentLocations, errorMsg: Constants.Errors.noStudentLocationsMsg, presenting: { alert in
                sender.present(alert, animated: true)
            })
        }
        
    })
}
