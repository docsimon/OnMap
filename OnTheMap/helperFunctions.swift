//
//  helperFunctions.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
func addPin(){
    
}

func updatePosition() -> String?{
    guard let userKey = appDelegate.userLoginData?.userKey else {
        print("No user key")
        return nil
    }
    guard let studentArray = appDelegate.studentsLocation else {
        print("No students location")
        return nil
    }
    
    let userData = studentArray.filter { student in
        if let studentId = student["uniqueKey"] as? String, studentId == userKey{
            print(studentId, " ", userKey)
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
