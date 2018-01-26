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
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func connectAction(_ sender: UIButton) {
        outputLabel.text = "Logging in..."
        let http = RestClient()
        
        let user = http.login(completionHandler: { (user, error) in
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
                self.outputLabel.text = "Welcome, \(user.username)!"
                
                let games = http.getGames(completionHandler: { (games, error) in
                    if let error = error {
                        // got an error in getting the data, need to handle it
                        print("error calling POST for Games")
                        print(error)
                        return
                    }
                    guard let games = games else {
                        print("error getting games: result is nil")
                        return
                    }
                    // success :)
                    debugPrint(games)
                    DispatchQueue.main.async(execute: {
                        //perform all UI stuff here
                        self.outputLabel.text = "\(games[0].id)"
                    })
                })
                
                //må trekkes ut
                /*let game = http.getGame(id: 2180169928, completionHandler: { (game, error) in
                    if let error = error {
                        // got an error in getting the data, need to handle it
                        print("error calling POST for Game")
                        print(error)
                        return
                    }
                    guard let game = game else {
                        print("error getting game: result is nil")
                        return
                    }
                    // success :)
                    debugPrint(game)
                    DispatchQueue.main.async(execute: {
                        //perform all UI stuff here
                        self.outputLabel.text = "\(game.usedLetters)"
                    })
                })*/
                //må trekkes ut
            })
        })

    }	
    
}

