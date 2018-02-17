//
//  Protocols.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SetupNavBarButtons {
    @objc func pin()
    @objc func logout()
    
}

extension SetupNavBarButtons {
    
    func addBarButtons(vc: UIViewController){
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Pin"), style: .plain, target: self, action: #selector(pin))
    }
    
}
