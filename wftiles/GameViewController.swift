//
//  GameViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 27/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: Properties
    var game: Game!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    @IBOutlet weak var myLettersLabel: UILabel!
    @IBOutlet weak var remainingLettersLabel: UILabel!
    
    @objc func loadGame() {
        ProgressHUD.hud.show(text: "Loading...")
        guard let game = self.game else {
            print("No game to show")
            return
        }
        
        let gameWithTiles = RestClient.client.getGame(id: game.id, completionHandler: { (game, error) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling POST for Game")
                print(error)
                return
            }
            guard var game = game else {
                print("error getting game: result is nil")
                return
            }
            // success :)
            let language = Constants.letters.languages[game.ruleset]
            var letterCount = Constants.letters.counts[game.ruleset]
            let letterScore = Constants.letters.points[game.ruleset]
            //find remaining letters
            if let rack = game.player.rack {
                for letter in rack {
                    letterCount[letter]! -= 1
                }
            }
            if let usedLetters = game.usedLetters {
                for letter in usedLetters {
                    letterCount[letter]! -= 1
                }
            }
            //letterCount now holds count of remaining letters
            //call method for showing tiles in prefered fashion (now shown as all letters left)
            var remainingLetters = [String]()
            for (letter, count) in letterCount {
                for _ in 0..<count {
                    remainingLetters.append(letter)
                }
            }
            let locale = Locale(identifier: Constants.letters.locales[game.ruleset])
            let sortedRack = game.player.rack!.sorted {
                $0.compare($1, locale: locale) == .orderedAscending
            }
            let sortedRemainingLetters = remainingLetters.sorted {
                $0.compare($1, locale: locale) == .orderedAscending
            }
                        
            self.game = game
            DispatchQueue.main.async(execute: {
                //perform all UI stuff here
                self.remainingLettersLabel.text = "\(sortedRemainingLetters)"
                self.opponentImageView.image = AppData.store.getAvatar(id: game.opponent.id)!.image
                self.opponentLabel.text = game.opponent.username
                self.scoreLabel.text = "(\(game.player.score) - \(game.opponent.score))"
                if let lastMove = game.lastMove {
                    self.lastMoveLabel.text = "Last move: \(lastMove.move_type)"
                } else {
                    self.lastMoveLabel.text = "No moves made"
                }
                self.myLettersLabel.text = "\(sortedRack)"
                ProgressHUD.hud.hide()
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //load game
        loadGame()

        NotificationCenter.default.addObserver(self, selector:#selector(loadGame), name:NSNotification.Name.UIApplicationDidBecomeActive, object:UIApplication.shared
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
}
