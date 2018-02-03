//
//  ListViewController.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, SetupNavigationBarWithButtons
{
    override func viewDidLoad() {
        super.viewDidLoad()
       addBarButtons(pinSelector: #selector(pin), refreshSelector: #selector(reload),navigationItem: navigationItem)
    }
    
    @objc func pin(){
        print("cippa pin")
    }
    @objc func reload(){
        print("cippa refresh")
    }
    
    deinit {
        print("deinit list")
    }
}
