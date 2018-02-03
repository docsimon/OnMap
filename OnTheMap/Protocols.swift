//
//  Protocols.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

protocol SetupNavigationBarWithButtons {
   
}




extension SetupNavigationBarWithButtons {
    func addBarButtons(pinSelector: Selector, refreshSelector: Selector, navigationItem: UINavigationItem){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"Pin"), style: .plain, target: self, action: pinSelector)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Refresh"), style: .plain, target: self, action: refreshSelector)
    }
}
