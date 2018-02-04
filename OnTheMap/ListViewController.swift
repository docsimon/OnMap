//
//  ListViewController.swift
//  OnTheMap
//
//  Created by doc on 03/02/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, SetupNavBarButtons, UITableViewDelegate, UITableViewDataSource
{
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons(vc: self)
    }
    
    @objc func pin(){
        performSegue(withIdentifier: "pinList", sender: nil)
    }
    @objc func reload(){
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Simone"
        cell.detailTextLabel?.text = "London, UK"
        return cell
    }
    
    deinit {
        print("deinit list")
    }
}
