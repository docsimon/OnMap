//
//  Constants.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

struct Constants {
    
    static let baseScheme = "https"
    static let udacityBaseUrl = "www.udacity.com"
    static let udacityAuthPath = "/api/session"
    static let parseBaseUrl = "parse.udacity.com"
    static let parseGetPath = ""
    static let parsePostPath = ""
    
    struct Errors {
        static let loginTitle = "Login Error"
        static let loginMsg = "Check username and/or password"
        static let urlTitle = "Invalid url"
        static let urlMsg = "The url is empty"
        static let encodingBodyTitle = "Error encoding body"
        static let encodingBodyMsg = "Couldn't encode body for POST"
        static let clientTitle = "Connection error"
        static let dataTitle = "Data error"
        static let dataMsg = "Data received are empty or corrupted"
    }
    

}
