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

// Login response Json from Udacity
struct LoginResponse: Codable {
    let account: LoginAccount
    let session: LoginSession
}
struct LoginAccount: Codable {
    let registered: Bool
    let key: String
}
struct LoginSession: Codable {
    let id: String
    let expiration: String
}

// Send student location POST body

struct StudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

// Response after posting the user location
struct StudentLocationResponse: Codable {
    let createdAt: String
    let objectId: String
}

// Response after posting the user location
struct StudentLocationUpdateResponse: Codable {
    let updatedAt: String
}

// Response after  GET students location
struct Results: Codable {
    let results: [StudentLocationData?]
}

struct StudentLocationData: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
