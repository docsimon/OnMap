//
//  SharedData.swift
//  OnTheMap
//
//  Created by doc on 25/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation

class SharedData: NSObject {
    static let shared = SharedData()
    var studentsInformations = [StudentInformation]()
}
