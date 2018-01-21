//
//  ClientHelper.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation


func displayError(_ error: String, _ domain: String, completion: CompletionClosure) {
    print(error)
    let userInfo = [NSLocalizedDescriptionKey : error]
    completion(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
}
