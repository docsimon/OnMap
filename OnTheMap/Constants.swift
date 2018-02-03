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
        static let parsingLoginJson = "Error parsing login response json"
        static let userStatus = "User not registered"
        static let userKey = "User key not valid"
        static let userSession = "User session not valid"
        static let loginUnknownErrorTitle = "Unknown Error"
        static let loginUnknownErrorMsg = "Please try to login again"
    }
    
    struct Apis {
        static let parseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
}
