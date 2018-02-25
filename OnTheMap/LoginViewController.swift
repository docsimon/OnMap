//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by doc on 21/01/2018.
//  Copyright © 2018 Simone Barbara. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
       login(username.text, password.text)
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
        let request = buildRequest(url: murl, method: "POST", body: body, apis: false)
        // make the connection
        makeConnection(request: request, securityCheck: true, jsonHandler: parseAuthJson, completion: {(data, error) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                displayError(errorTitle: Constants.Errors.clientTitle, errorMsg: error!.localizedDescription, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            
            // The "data" is a parsed dictionary here
            guard let data = data else {
                print(Constants.Errors.dataTitle)
                displayError(errorTitle: Constants.Errors.dataTitle, errorMsg: Constants.Errors.dataMsg, presenting: { alert in
                    self.present(alert, animated: true)
                })
                return
            }
            
            if let key = (data[0] as? LoginResponse)?.account.key, let session = (data[0] as? LoginResponse)?.session.id {
                DispatchQueue.main.async {
                    appDelegate.userLoginData = UserLoginData(userKey:key, userSession: session)
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
    
    deinit {
        print("deallocated")
    }
}
// TextField protocol implementation
extension LoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // The following implementation has been proposed by Udacity instructor in order to make
    // the textfields visible after the keyboard appears
    @objc func keyboardNotification(notification: NSNotification) {
        if username.isEditing || password.isEditing {
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                
                let viewOriginFrame: CGFloat!
                
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    viewOriginFrame = 0
                } else {
                    viewOriginFrame = -200 // You can change this values to an ideal value according with the screen, textfields and button size.
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: {
                                self.view.frame.origin.y = viewOriginFrame
                                self.view.layoutIfNeeded() },
                               completion: nil)
            }
        }
    }
}
