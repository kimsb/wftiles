//
//  ViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 23/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logger inn hvis man har innloggingsdata lagret
        if let user = AppData.store.getUser() {
            
            print("USER: \(user.email) : \(user.username) : \(user.password) : \(user.loginMethod)")
            
            let loginValue = user.loginMethod == "email" ? user.email : user.username
            userTextField.text = loginValue
            passwordTextField.text = user.password
            login(loginMethod: user.loginMethod, loginValue: loginValue, password: user.password)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(loginMethod: String, loginValue: String, password: String) {
        
        Alerts.shared.show(text: "Logging in...", delay: 0.5)
        
        let user = RestClient.client.login(loginMethod: loginMethod, loginValue: loginValue, password: password, completionHandler: { (user, errorString) in
            if let errorString = errorString {
                // got an error in getting the data, need to handle it
                print("error calling POST for Login (ViewController)")
                print(errorString)
                //BØR LEGGE TIL MULIGHET FOR Å HIDE HUD UANSETT OM DET HAR GÅTT TID ELLER IKKE
                Alerts.shared.alert(view: self, title: "Login failed", errorString: errorString)
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
    
    //MARK: Actions
    @IBAction func connectAction(_ sender: UIButton) {
        
        //DENNE MÅ DET VÆRE BEDRE LOGIKK PÅ, OG FALLBACK HVIS LOGIN MED LOGINMETHOD:EMAIL IKKE FUNKER FOR LOGINVALUE MED '@'
        let loginMethod = userTextField.text!.range(of:"@") != nil ? "email" : "username"
        
        login(loginMethod: loginMethod, loginValue: userTextField.text!, password: passwordTextField.text!)
    }	
    
}

