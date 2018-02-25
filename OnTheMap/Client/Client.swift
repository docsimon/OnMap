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

func makeConnection(request: URLRequest,securityCheck: Bool, jsonHandler: @escaping JsonHandlerFunction, completion: @escaping (_ jsonData: [String:Any]?, _ error: Error?) -> Void ) {
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
        
        // error checking
        guard (error == nil) else {
            sendError((error?.localizedDescription) ?? "Error", "makeConnection", completion: completion)
            return
        }
        // response checking
        if let statusCode = (response as? HTTPURLResponse)?.statusCode{
            guard checkResponseCode(code: statusCode) == true else {
                sendError(translateErrorResponseCode(code: statusCode), "makeConnection", completion: completion)
                return
            }
        }else {
            sendError("Status code unknown", "makeConnection", completion: completion)
            return
        }
        
        // data checking
        guard let data = data else {
            sendError("Error receiving the Data", "makeConnection", completion: completion)
            return
        }
        
        if securityCheck {
            // security feature needed to correctly parse the json from Udacity
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            jsonHandler(newData, completion)
        }else {
            // This function is passed as parameter and is tailored on the type
            // of json I need to send/parse
            jsonHandler(data, completion)
            
        }
        
    })
    task.resume()
}

func checkResponseCode(code: Int) -> Bool {
    let successCode = [200, 201, 202, 203, 204]
    return successCode.contains(code)
}

func translateErrorResponseCode (code: Int) -> String {
    switch code {
    // 4xx Client errors
    case 400:
        return "Code 400: Bad Request"
    case 401:
        return "Code 401: Unauthorized"
    case 403:
        return "Code 403: Forbidden"
    case 404:
        return "Code 404: Not Found"
    case 408:
        return "Code 408: Request Timeout"
   // 4xx Server errors
    case 500:
        return "Code 500: Internal Server Error"
    case 502:
        return "Code 502: Bad Gateway"
    case 503:
        return "Code 503: Service Unavailable"
    case 504:
        return "Code 504: Gateway Timeout"
    default:
    return "Generic network error"
    }
}
