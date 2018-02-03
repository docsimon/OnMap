//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var userLoginData: UserLoginData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //login(username.text, password.text)
        self.performSegue(withIdentifier: "Map", sender: nil)

    }
    
    func login(_ username: String?, _ password: String?) {
        
        // check if the username and password are valid
        guard loginDataAreValid(username: username, password: password) == true, let username = username, let password = password else {
            print(Constants.Errors.loginTitle)
            displayError(errorTitle: Constants.Errors.loginTitle, errorMsg: Constants.Errors.loginMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // build and check the url
        let url = buildUrl(baseUrl: Constants.udacityBaseUrl, path: Constants.udacityAuthPath, query: nil)
        guard let murl = url else {
            print(Constants.Errors.urlTitle)
            displayError(errorTitle: Constants.Errors.urlTitle, errorMsg: Constants.Errors.urlMsg, presenting: {alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // create the POST body, the Swift 4 way 😁
        let loginData = LoginData(username: username, password: password)
        let loginBody = LoginBody(udacity: loginData)
        guard let body = makeBody(bodyStructure: loginBody) else {
            print("Body is empty ")
            displayError(errorTitle: Constants.Errors.encodingBodyTitle, errorMsg:Constants.Errors.encodingBodyMsg , presenting: { alert in
                self.present(alert, animated: true)
            })
            return
        }
        
        // create the url POST request 
        let request = buildRequest(url: murl, method: "POST", body: body)
        makeConnection(request: request, jsonHandler: parseAuthJson, completion: {(data, error) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                displayError(errorTitle: Constants.Errors.clientTitle, errorMsg: error!.localizedDescription, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            
            guard let data = data else {
                print(Constants.Errors.dataTitle)
                displayError(errorTitle: Constants.Errors.dataTitle, errorMsg: Constants.Errors.dataMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            if let key = data["key"] as? String, let session = data["sessionId"] as? String {
                self.userLoginData = UserLoginData(userKey:key, userSession: session)
                //print(userLoginData.userKey, " ", userLoginData.userSession)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Map", sender: nil)
                }
            }else {
                print(Constants.Errors.dataTitle)
                displayError(errorTitle: Constants.Errors.loginUnknownErrorTitle, errorMsg: Constants.Errors.loginUnknownErrorMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
      
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? MapViewController{
            destVC.sid = "cippa"
        }
    }
    
    deinit {
        print("deallocated")
    }
}
