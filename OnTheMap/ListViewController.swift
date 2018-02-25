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
        if let objectId = updatePosition(studentArray: SharedData.shared.studentsInformations as? [StudentInformation]) {
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
    
    func validateSessionLogout(data: Codable?){
        if let _ = (data as? DeleteResponse)?.session {
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
    
    func reloadTable(data: [StudentInformation?]){
        DispatchQueue.main.async{
            SharedData.shared.studentsInformations = data
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
        SharedData.shared.studentsInformations.removeAll()
        fetchStudentsLocation(completion: reloadTable, sender: self)
    }
    
    deinit {
        print("deinit list")
    }
}

extension ListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedData.shared.studentsInformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let firstName = SharedData.shared.studentsInformations[indexPath.row]?.firstName, let lastName = SharedData.shared.studentsInformations[indexPath.row]?.lastName {
            cell.textLabel?.text = "\(firstName) \(lastName)"
        }else {
            cell.textLabel?.text = "Unknown"
        }
        cell.detailTextLabel?.text = SharedData.shared.studentsInformations[indexPath.row]?.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let mediaUrl = SharedData.shared.studentsInformations[indexPath.row]?.mediaURL, let url = URL(string: mediaUrl) {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}
