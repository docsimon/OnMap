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
    
    let jsonDecoder = JSONDecoder()
    let loginResponse: LoginResponse?
    do {
        loginResponse = try jsonDecoder.decode(LoginResponse.self, from: data)
    }catch {
        print("Error parsing login response json")
        sendError("Error parsing login response json", "parseAuthJson", completion: completion)
        return
    }
    
    guard let registered = loginResponse?.account.registered, registered == true else{
        sendError("User not registered", "parseAuthJson", completion: completion)
        return
    }
    
    guard let key = loginResponse?.account.key else {
        sendError("User key not valid", "parseAuthJson", completion: completion)
        return
    }
   
    guard let session = loginResponse?.session.id else {
        sendError("User session not valid", "parseAuthJson", completion: completion)
        return
    }
    
    let authData = ["key": key, "sessionId": session]
      completion(authData, nil)
}
