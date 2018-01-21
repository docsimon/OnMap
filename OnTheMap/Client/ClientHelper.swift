//
//  ClientHelper.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

enum HttpType {
    case POST
    case PUT
}

// Use this function to send the error message to the calling function
func sendError(_ error: String, _ domain: String, completion: CompletionClosure) {
    print(error)
    let userInfo = [NSLocalizedDescriptionKey : error]
    completion(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
}

// this function helps to build the URL
func buildUrl(baseUrl: String, path:String?, query: [String:String]?) -> URL?{
    var urlComponents = URLComponents(string: baseUrl)
    if let path = path {
        urlComponents?.path = path
    }
    if let query = query {
        var queries = [URLQueryItem]()
        for (key, value) in query {
            let queryItem = URLQueryItem(name: key, value: value)
            queries.append(queryItem)
        }
        urlComponents?.queryItems = queries
    }
    return urlComponents?.url
}

// The following function builds a request based on the Http method type
func buildRequest(url: URL, method: String?, body: Data?) -> URLRequest{
    
    var request = URLRequest(url: url)
    
    // if the method is POST or PUT
    if let method = method {
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
    }
    // else it's GET
    return request
}

// The following function helps to create a body for the POST/PUT requests
func makeBody(bodyStructure: String) -> Data? {
    let body = bodyStructure.data(using: String.Encoding.utf8)
    return body
}


