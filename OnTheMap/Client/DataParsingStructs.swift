//
//  DataParsingStructs.swift
//  OnTheMap
//
//  Created by doc on 27/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

// Struct to make easier the JSON parsing, both for GET and POST methods
// Since Swift 4 it is possible to map the JSON with structs

// We send this body to Udacity when we want to login
struct LoginBody: Codable {
    let udacity: LoginData
}
struct LoginData: Codable {
    let username: String
    let password: String
}
