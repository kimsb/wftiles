//
//  GameCollectionViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 09/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TileCollectionViewCell"

class GameCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var preferencesButton: UIButton!
    @IBOutlet var gameCollectionView: UICollectionView!
    private var game: Game!
    private var remainingLetters = [String]()
    
    func setGame(game: Game) {
        self.game = game
        remainingLetters = game.getRemainingLetters()
    }
    
    func loginAndTryAgain() -> Void {
        if let user = AppData.shared.getUser() {
            let loginValue = user.loginMethod == "email" ? user.email : user.username
            RestClient.client.login(loginMethod: user.loginMethod, loginValue: loginValue, password: user.password, completionHandler: { (user, errorString) in
                if let errorString = errorString {
                    print("error login and try again")
                    print(errorString)
                    Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "loadingFailed"), errorString: "")
                    return
                }
                self.loadGame()
            })
        }
    }
    
    @objc func loadGame() {
        if Texts.shared.unsupportedLanguage(ruleset: game.ruleset) {
            Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "unsupportedLanguage"), errorString: "")
            return
        }
        Alerts.shared.show(text: Texts.shared.getText(key: "pleaseWait"))
        guard let game = self.game else {
            print("No game to show")
            return
        }
        
        RestClient.client.getGame(id: game.id, completionHandler: { (game, errorString) in
            if let errorString = errorString {
                // got an error in getting the data, need to handle it
                print("error calling POST for Game")
                if errorString == "login_required" {
                    self.loginAndTryAgain()
                    return
                }
                Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "loadingFailed"), errorString: errorString)
                return
            }
            guard let game = game else {
                print("error getting game: result is nil")
                return
            }
            // success :)
            
            AppData.shared.setGameWithUsedLetters(game: game)

            DispatchQueue.main.async(execute: {
                self.game = game
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
        
        self.navigationItem.title = game.opponent.username
        
        preferencesButton.setTitle("  \u{2699}\u{0000FE0E} ", for: .normal)
        preferencesButton.titleLabel?.font = preferencesButton.titleLabel?.font.withSize(30)
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.gameCollectionView.reloadData()
        })
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if(section==0) {
            if #available(iOS 11.0, *) {
                return CGSize(width:collectionView.safeAreaLayoutGuide.layoutFrame.size.width, height:110)
            } else {
                return CGSize(width:collectionView.frame.size.width, height:110)
            }
        } else {
            return CGSize(width:collectionView.frame.size.width, height:40)
        }
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(section==0) {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    //for header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GameHeaderView", for: indexPath) as! GameHeaderView
            
            reusableview.avatarImageView.image = AppData.shared.getAvatar(id: game.opponent.id)!.image
            reusableview.addDiffLabel(myScore: game.player.score, opponentScore: game.opponent.score)
            reusableview.languageLabel.text = Texts.shared.getGameLanguage(ruleset: game.ruleset)
            reusableview.scoreLabel.text = "\(game.player.score) - \(game.opponent.score)"
            reusableview.lastMoveLabel.text = game.getLastMoveText()
            return reusableview
        } else {
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TileHeaderView", for: indexPath) as! TileHeaderView
            
            if indexPath.section == 1 {
                reusableview.headerLabel.text = Texts.shared.getText(key: "yourTiles")
            } else {
                reusableview.headerLabel.text = Texts.shared.getText(key: "remainingTiles")
            }

            return reusableview
        }
    }
    
    //for å sette str på cell
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if AppData.shared.showSummary() && indexPath.section == 2 {
            return CGSize(width: 80, height: 40)
        }
        return CGSize(width: 40, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        if section == 1 {
            return game.player.rack!.count
        }

        if (AppData.shared.showSummary()) {
            return Constants.tiles.letters(ruleset: game.ruleset).count
        }
        return game.letterCount.values.reduce(0, +)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if AppData.shared.showSummary() && indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileSummaryCollectionViewCell", for: indexPath as IndexPath) as! TileSummaryCollectionViewCell
            cell.tileLetterLabel.text = Constants.tiles.letters(ruleset: game.ruleset)[indexPath.item]
            let score = Constants.tiles.points[game.ruleset][cell.tileLetterLabel.text!]!
            cell.tileScoreLabel.text = score > 0 ? String(describing: score) : ""
            cell.tileView.layer.borderColor = UIColor.black.cgColor
            cell.tileView.layer.borderWidth = 1
            cell.tileView.layer.cornerRadius = 4
            
            let count = game.letterCount[cell.tileLetterLabel.text!]!

                cell.letterCountLabel.text = "\(count)"
                if (count == 0) {
                    cell.tileView.backgroundColor = UIColor.lightGray
                } else {
                    cell.tileView.backgroundColor = UIColor(red: CGFloat(251/255.0), green: CGFloat(251/255.0), blue: CGFloat(241/255.0), alpha: CGFloat(1.0))
                }
            
            return cell
        }
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TileCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        if indexPath.section == 1 {
            cell.letterLabel.text = game.player.rack![indexPath.item]
        } else {
            cell.letterLabel.text = remainingLetters[indexPath.item]
        }
        let score = Constants.tiles.points[game.ruleset][cell.letterLabel.text!]!
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

    @IBAction func popoverAction(_ sender: Any) {
        self.performSegue(withIdentifier: "popover", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popover" {
            let destination = segue.destination
            if let popover = destination.popoverPresentationController {
                popover.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func viewSwitchChangedValue() {
        self.gameCollectionView.reloadData()
    }
    
    func sortSwitchChangedValue() {
        remainingLetters = game.getRemainingLetters()
        self.gameCollectionView.reloadData()
    }
    
    
    
}
