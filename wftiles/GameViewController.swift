//
//  GameViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 27/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Properties
    var game: Game!
    var sortedRack = [String]()
    var sortedRemainingLetters = [String]()
    
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    @IBOutlet weak var rackCollectionView: UICollectionView!
    @IBOutlet weak var remainingTilesCollectionView: UICollectionView!
    
    @objc func loadGame() {
        Alerts.shared.show(text: "Loading...")
        guard let game = self.game else {
            print("No game to show")
            return
        }
        
        let gameWithTiles = RestClient.client.getGame(id: game.id, completionHandler: { (game, errorString) in
            if let errorString = errorString {
                // got an error in getting the data, need to handle it
                print("error calling POST for Game")
                Alerts.shared.alert(view: self, title: "Loading failed", errorString: errorString)
                return
            }
            guard var game = game else {
                print("error getting game: result is nil")
                return
            }
            // success :)
            let language = Constants.tiles.languages[game.ruleset]
            var letterCount = Constants.tiles.counts[game.ruleset]
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
            let locale = Locale(identifier: Constants.tiles.locales[game.ruleset])
            self.sortedRack = game.player.rack!.sorted {
                $0.compare($1, locale: locale) == .orderedAscending
            }
            self.sortedRemainingLetters = remainingLetters.sorted {
                $0.compare($1, locale: locale) == .orderedAscending
            }
                        
            self.game = game
            DispatchQueue.main.async(execute: {
                //perform all UI stuff here
                //self.remainingLettersLabel.text = "\(sortedRemainingLetters)"
                self.opponentImageView.image = AppData.store.getAvatar(id: game.opponent.id)!.image
                self.opponentLabel.text = game.opponent.username
                self.scoreLabel.text = "(\(game.player.score) - \(game.opponent.score))"
                if let lastMove = game.lastMove {
                    self.lastMoveLabel.text = "Last move: \(lastMove.move_type)"
                } else {
                    self.lastMoveLabel.text = "No moves made"
                }
                //self.myLettersLabel.text = "\(sortedRack)"
                self.rackCollectionView.reloadData()
                self.remainingTilesCollectionView.reloadData()
                Alerts.shared.hide()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.rackCollectionView {
            return sortedRack.count
        }
        return sortedRemainingLetters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "TileCollectionViewCell"
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TileCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if collectionView == self.rackCollectionView {
            cell.letterLabel.text = self.sortedRack[indexPath.item]
            cell.scoreLabel.text = String(describing: Constants.tiles.points[game.ruleset][self.sortedRack[indexPath.item]]!)
        } else if collectionView == self.remainingTilesCollectionView {
            cell.letterLabel.text = self.sortedRemainingLetters[indexPath.item]
            cell.scoreLabel.text = String(describing: Constants.tiles.points[game.ruleset][self.sortedRemainingLetters[indexPath.item]]!)
        }
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 4
        return cell
    }
}
