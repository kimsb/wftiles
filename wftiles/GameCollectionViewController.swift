//
//  GameCollectionViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 09/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TileCollectionViewCell"

class GameCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK: Properties
    @IBOutlet var gameCollectionView: UICollectionView!
    var game: Game!
    var sortedRack = [String]()
    var sortedRemainingLetters = [String]()
    var showSummary = true
    var letterCount = [String:Int]()
    
    //dette må gjøres penere
    private let norwegianLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W", "Y", "Æ", "Ø", "Å", ""]
    
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
            let language = Constants.letters.languages[game.ruleset]
            var letterCount = Constants.letters.counts[game.ruleset]
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
            
            //for visning av summary
            self.letterCount = letterCount
            
            //letterCount now holds count of remaining letters
            //call method for showing tiles in prefered fashion (now shown as all letters left)
            var remainingLetters = [String]()
            for (letter, count) in letterCount {
                for _ in 0..<count {
                    remainingLetters.append(letter)
                }
            }
            let locale = Locale(identifier: Constants.letters.locales[game.ruleset])
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
                /*self.opponentImageView.image = AppData.store.getAvatar(id: game.opponent.id)!.image
                self.opponentLabel.text = game.opponent.username
                self.scoreLabel.text = "(\(game.player.score) - \(game.opponent.score))"
                if let lastMove = game.lastMove {
                    self.lastMoveLabel.text = "Last move: \(lastMove.move_type)"
                } else {
                    self.lastMoveLabel.text = "No moves made"
                }*/
                //self.myLettersLabel.text = "\(sortedRack)"
                //self.rackCollectionView.reloadData()
                //self.remainingTilesCollectionView.reloadData()
                self.gameCollectionView.reloadData()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let headerNib = UINib(nibName: "GameHeaderView", bundle: nil)
        self.gameCollectionView.register(headerNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "GameHeaderView")
        
        let summaryCellNib = UINib(nibName: "TileSummaryCollectionViewCell", bundle: nil)
        self.gameCollectionView.register(summaryCellNib, forCellWithReuseIdentifier: "TileSummaryCollectionViewCell")
        
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if(section==0) {
            return CGSize(width:collectionView.frame.size.width, height:110)
        } else {
            return CGSize(width:collectionView.frame.size.width, height:50)
        }
    }
    
    //for header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GameHeaderView", for: indexPath) as! GameHeaderView
            
            reusableview.avatarImageView.image = AppData.store.getAvatar(id: game.opponent.id)!.image
            reusableview.opponentLabel.text = game.opponent.username
            reusableview.scoreLabel.text = "(\(game.player.score) - \(game.opponent.score))"
            if let lastMove = game.lastMove {
                reusableview.lastMoveLabel.text = "Last move: \(lastMove.move_type)"
            } else {
                reusableview.lastMoveLabel.text = "No moves made"
            }
            
            return reusableview
        } else {
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TileHeaderView", for: indexPath) as! TileHeaderView
            
            if indexPath.section == 1 {
                reusableview.headerLabel.text = "My letters"
            } else {
                reusableview.headerLabel.text = "Remaining letters"
            }
            
            return reusableview
        }
    }
    
    //for å sette str på cell
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if showSummary && indexPath.section == 2 {
            return CGSize(width: 80, height: 40)
        }
        return CGSize(width: 40, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        if section == 1 {
            return sortedRack.count
        }
        
        //TEST
        if (showSummary) {
            return norwegianLetters.count
        }
        return sortedRemainingLetters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showSummary && indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileSummaryCollectionViewCell", for: indexPath as IndexPath) as! TileSummaryCollectionViewCell
            cell.tileLetterLabel.text = self.norwegianLetters[indexPath.item]
            let score = Constants.letters.points[game.ruleset][cell.tileLetterLabel.text!]!
            cell.tileScoreLabel.text = score > 0 ? String(describing: score) : ""
            cell.tileView.layer.borderColor = UIColor.black.cgColor
            cell.tileView.layer.borderWidth = 1
            cell.tileView.layer.cornerRadius = 4
            
            let count = self.letterCount[cell.tileLetterLabel.text!]
            if count == nil {
                cell.letterCountLabel.text = "0"
            } else {
                cell.letterCountLabel.text = "\(count!)"
            }
            
            return cell
        }
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TileCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if indexPath.section == 1 {
            cell.letterLabel.text = self.sortedRack[indexPath.item]
        } else {
            cell.letterLabel.text = self.sortedRemainingLetters[indexPath.item]
        }
        let score = Constants.letters.points[game.ruleset][cell.letterLabel.text!]!
        cell.scoreLabel.text = score > 0 ? String(describing: score) : ""
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 4
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
