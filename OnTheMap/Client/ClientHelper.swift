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
    var urlComponents = URLComponents()
    
    urlComponents.scheme = Constants.baseScheme
    urlComponents.host = baseUrl
    if let path = path {
        urlComponents.path = path
    }
    if let query = query {
        var queries = [URLQueryItem]()
        for (key, value) in query {
            let queryItem = URLQueryItem(name: key, value: value)
            queries.append(queryItem)
        }
        urlComponents.queryItems = queries
    }
    return urlComponents.url
}

// The following function builds a request based on the Http method type
func buildRequest(url: URL, method: String?, body: Data?, apis: Bool) -> URLRequest{
    
    var request = URLRequest(url: url)
    if let method = method {
        request.httpMethod = method
        if method == "DELETE" {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        // if the method is POST or PUT
        else {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
    }
    if apis == true {// fetching students location data
        request.addValue(Constants.Apis.parseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Apis.parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    }
    
    return request
}

// The following function helps to create a body for the POST/PUT requests
func makeBody<T: Codable>(bodyStructure: T) -> Data? {
    let jsonEncoder = JSONEncoder()
    let jsonPOSTData: Data?
    do {
        jsonPOSTData = try jsonEncoder.encode(bodyStructure)
    }catch{
        print("Encoding error")
        return nil
    }
    return jsonPOSTData
}

func loginDataAreValid(username:String?, password: String?) -> Bool{
    guard (username?.isEmpty == false), (password?.isEmpty == false) else {
        return false
    }
    // TODO: add other checks on the username and password
    return true
}


