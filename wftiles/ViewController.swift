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
        let http = RestClient()
        http.login()
        sleep(2)
        http.getGameIds()
        sleep(2)
        
        let game = http.getGame(id: 2180169928, completionHandler: { (game, error) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling POST")
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

        })
        
    }	
    
}

