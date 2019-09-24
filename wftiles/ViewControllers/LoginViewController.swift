//
//  LoginViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 23/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alerts.shared.hide()
        
        self.navigationItem.title = "Wordfeud Tiles"
        
        loginInfoLabel.text = Texts.shared.getText(key: "loginInfo")
        userTextField.placeholder = Texts.shared.getText(key: "usernameEmail")
        passwordTextField.placeholder = Texts.shared.getText(key: "password")
        loginButton.setTitle(Texts.shared.getText(key: "login"), for: .normal)
        
        if let user = AppData.shared.getLastAttemptedLogin() {
            let loginValue = user.loginMethod == "email" ? user.email : user.username
            userTextField.text = loginValue
            passwordTextField.text = user.password
        } else {
            userTextField.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(loginMethod: String, loginValue: String, password: String) {
        
        Alerts.shared.show(text: Texts.shared.getText(key: "loggingIn"))
        
        RestClient.client.login(loginMethod: loginMethod, loginValue: loginValue, password: password, completionHandler: { (user, errorString) in
            if let errorString = errorString {
                // got an error in getting the data, need to handle it
                print("error calling POST for Login (ViewController)")
                print(errorString)
                //BØR LEGGE TIL MULIGHET FOR Å HIDE HUD UANSETT OM DET HAR GÅTT TID ELLER IKKE
                Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "loginFailed"), errorString: errorString)
                return
            }
            guard let user = user else {
                print("error getting user: result is nil")
                return
            }
            // success :)
            debugPrint(user)
            DispatchQueue.main.async(execute: {
                //perform all UI stuff here
                self.performSegue(withIdentifier: "loginToTableSegue", sender: nil)
            })
        })
    }
    
    func login() {
        let loginMethod = userTextField.text!.range(of:"@") != nil ? "email" : "username"
        login(loginMethod: loginMethod, loginValue: userTextField.text!, password: passwordTextField.text!)
    }
    
    //MARK: Actions
    @IBAction func connectAction(_ sender: UIButton) {
        if userTextField.text! == "" {
            Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "loginFailed"), errorString: Texts.shared.getText(key: "unknownUsername"))
            return
        }
        if passwordTextField.text! == "" {
            Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "loginFailed"), errorString: Texts.shared.getText(key: "wrongPassword"))
            return
        }
        login()
    }	
    
    @IBAction func nextFromUserTextField(_ sender: Any) {
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func goFromPasswordTextField(_ sender: Any) {
        login()
    }
}

