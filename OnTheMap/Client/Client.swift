//
//  Client.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

//
// The purpose of this file is to contain the functions necessary to create
// a connection with the remote servers (Udacity for authentication and Parse for retrieving students location data)
 //
// I'm going to use only functions and Structs instead of Classes

import Foundation

// This function create a connection with the remote server and fetch the data that are passed to a function, which, in turn, is passed as parameter of the function itself.

func makeConnection(request: URLRequest, jsonHandler: JsonHandlerFunction, completion: @escaping (_ jasonData: [String:Any]) -> Void ) {
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        
        // error checking
        guard (error == nil) else {
            print("Error")
            // provide an alert here
            return
        }
        // response checking
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, checkResponseCode(code: statusCode) == true else {
            print("Not successfull")
            // provide an alert here
            return
        }
        
        // data checking
        guard let data = data else {
            print("Bad data")
            // provide an alert here
            return
        }
        
        })
    task.resume()
}

func checkResponseCode(code: Int) -> Bool {
    let successCode = [200, 201, 202, 203, 204]
    return successCode.contains(code)
}
