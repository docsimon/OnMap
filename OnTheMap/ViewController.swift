//
//  ViewController.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        
        let url = buildUrl(baseUrl: Constants.udacityBaseUrl, path: Constants.udacityAuthPath, query: nil)
        
        let bodyString = "{\"udacity\": {\"username\": \"simone.milano12@gmail.com\", \"password\": \"***REMOVED***\"}}"
        let body = makeBody(bodyStructure: bodyString)
        
        guard let murl = url else {
            print("problemz ", url?.absoluteString)
            return
        }
        let request = buildRequest(url: murl, method: "POST", body: body)
        
        makeConnection(request: request, jsonHandler: parseAuthJson, completion: {(data, error) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Empry data")
                return
            }
            
            print(data["key"] as! String, " ", data["sessionId"] as! String)
            
        })

    }
}
