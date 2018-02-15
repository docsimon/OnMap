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
    var students: [[String:Any]] = []
    let app = UIApplication.shared
    @IBOutlet weak var tableView: UITableView!
    var objectId: String?
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons(vc: self)
        fetchData()
        
    }
    
    @objc func pin(){
        if let objectId = updatePosition(studentArray: students) {
            // display the alert
            self.objectId = objectId
            displayUpdateOptions(optionTitle: "Do you vant to update your position?", action: updateLocation, presenting:{alert in
                self.present(alert, animated: true)
            })
        }
    }
    
    @objc func reload(){
        fetchData()
    }
    
    func reloadTable(data: [[String:Any]]){
        students = data
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func updateLocation(){
        performSegue(withIdentifier: "pinList", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? NewLocationViewController {
            destVC.objectId = objectId
        }
    }
    
    func fetchData(){
        students.removeAll()
        fetchStudentsLocation(completion: reloadTable, sender: self)
    }
    
    deinit {
        print("deinit list")
    }
}

extension ListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let firstName = students[indexPath.row]["firstName"], let lastName = students[indexPath.row]["lastName"] {
            counter = counter + 1
            let cippa: Int = counter
            let soooga = String(describing: cippa)
            cell.textLabel?.text = "\(firstName) \(lastName) \(soooga)"
        }else {
            cell.textLabel?.text = "Unknown"
        }
        cell.detailTextLabel?.text = students[indexPath.row]["mediaURL"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let mediaUrl = students[indexPath.row]["mediaURL"] as? String, let url = URL(string: mediaUrl) {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
