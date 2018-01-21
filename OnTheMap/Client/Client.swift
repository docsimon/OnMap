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

func makeConnection(request: URLRequest, jsonHandler: @escaping JsonHandlerFunction, completion: @escaping (_ jsonData: [String:Any]?, _ error: Error?) -> Void ) {
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        
//        func displayError(_ error: String) {
//            print(error)
//            let userInfo = [NSLocalizedDescriptionKey : error]
//            completion(nil, NSError(domain: "makeConnection", code: 1, userInfo: userInfo))
//        }
        
        // error checking
        guard (error == nil) else {
            displayError((error?.localizedDescription) ?? "Error", "makeConnection", completion: completion)
            return
        }
        // response checking
        if let statusCode = (response as? HTTPURLResponse)?.statusCode{
            guard checkResponseCode(code: statusCode) == true else {
                displayError("Status code: \(String(describing: statusCode))", "makeConnection", completion: completion)
                return
            }
        }else {
            displayError("Status code unknown", "makeConnection", completion: completion)
            return
        }
        
        // data checking
        guard let data = data else {
            displayError("Error receiving the Data", "makeConnection", completion: completion)
            return
        }
        
        // This function is passed as parameter and is tailored on the type
        // of json I need to parse
        jsonHandler(data, completion)
        
        })
    task.resume()
}

func checkResponseCode(code: Int) -> Bool {
    let successCode = [200, 201, 202, 203, 204]
    return successCode.contains(code)
}
