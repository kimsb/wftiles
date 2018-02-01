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
            
            //MÅ ENDRE DETTE NÅR IMPLEMENTERING AV LOGIN MED USERNAME ER FERDIG
            
            login(email: "kbovim@hotmail.com", password: user.password)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(email: String, password: String) {
        
        ProgressHUD.hud.show(text: "Logging in...")
        
        let user = RestClient.client.login(email: email, password: password, completionHandler: { (user, error) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling POST for Login")
                print(error)
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
        login(email: userTextField.text!, password: (passwordTextField.text!+"JarJarBinks9").sha1!)
    }	
    
}

