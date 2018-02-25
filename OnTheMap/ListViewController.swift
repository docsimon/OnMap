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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons(vc: self)
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    @objc func pin(){
        if let objectId = updatePosition(studentArray: students) {
            // display the alert
            self.objectId = objectId
            displayUpdateOptions(optionTitle: "Do you vant to update your position?", action: updateLocation, presenting:{alert in
                self.present(alert, animated: true)
            })
        }else{
            updateLocation()
        }
    }
    
    @objc func logout(){
        sessionLogout(completion: validateSessionLogout, sender: self)
    }
    
    func validateSessionLogout(data: [String:Any]){
        if let _ = data["id"] as? String {
            appDelegate.userLoginData = nil
            DispatchQueue.main.async {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }else{
            displayError(errorTitle: Constants.Errors.userSessionStatus, errorMsg: Constants.Errors.userSessionStatus, presenting: { alert in
                self.present(alert, animated: true)
            })
        }
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
            cell.textLabel?.text = "\(firstName) \(lastName)"
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
