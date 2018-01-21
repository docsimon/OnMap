//
//  DataParsing.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

// Contains different functions to parse different json files

import Foundation

typealias CompletionClosure = ([String:Any]?, Error?) -> Void
typealias JsonHandlerFunction = (Data, CompletionClosure) -> Void

// Function to parse the Json fetched after sending the Username and Password to
// Udacity
func parseAuthJson(data: Data, completion: CompletionClosure){
    guard let rootDictionary = deserializeJson(data: data)  else {
        sendError("Problem parsing JSON", "parseAuthJson", completion: completion)
        return
    }
    // Check if the auth process has been ok
    // Checking the account
    guard let accountData = rootDictionary["account"] as? [String:Any],(accountData["registered"] as! Bool) == true, let key = accountData["key"] as? String else {
        sendError("Authorization failed", "parseAuthJson", completion: completion)
        return
    }
    // Checking the session
    guard let sessionData = rootDictionary["session"] as? [String:Any], let id = sessionData["id"] as? String else {
        sendError("Problem creating the session ", "parseAuthJson", completion: completion)
        return
    }
    
    // Everything looks good, let's pass back to the calling function the dictionary with the key and the session id
    let authData = ["key": key, "sessionId": id]
    completion(authData, nil)
    
    
}

func deserializeJson(data: Data) -> [String:Any]?{
    
    let rootDictionary: [String:Any]?
    do {
        rootDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
    }catch {
        return nil
    }
    return rootDictionary
}

