//
//  Protocols.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import Foundation
import UIKit

protocol SetupNavigationBarWithButtons: class {
   
}

@objc protocol SetupNavBarButtons {
    @objc func pin()
    @objc func reload()
    
}

extension SetupNavBarButtons {
    
    func addBarButtons(vc: UIViewController){
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"Pin"), style: .plain, target: self, action: #selector(pin))
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Refresh"), style: .plain, target: self, action: #selector(reload))
    }
    
}

extension SetupNavigationBarWithButtons where Self: UIViewController {
    func addBarButtons(pinSelector: Selector, refreshSelector: Selector, navigationItem: UINavigationItem){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"Pin"), style: .plain, target: self, action: pinSelector)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Refresh"), style: .plain, target: self, action: refreshSelector)
    }
    
    func pin(){
        
    }
}
