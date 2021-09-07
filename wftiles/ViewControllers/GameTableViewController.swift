//
//  GameTableViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 26/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var languagesButton: UIButton!
    var games = Array(repeating: [Game](), count: 3)
    var customRefresh: UIRefreshControl!
    var overlay: UIView!
    
    @IBAction func logOutButtonPressed() {
        UIView.transition(with: self.navigationController!.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.navigationController!.view.addSubview(self.overlay)
        }, completion: nil)
        overlay.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"actionTest"))
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func actionTest() {
        removeOverlay()
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    func removeOverlay() {
        if (self.overlay != nil) {
            UIView.transition(with: self.navigationController!.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self.overlay.removeFromSuperview()
            }, completion: nil)
        }
    }
    
    @objc func switchUser() {
        removeOverlay()
        loginAndTryAgain()
        let user = AppData.shared.getUser()
        self.navigationItem.title = user != nil ? user!.presentableFullUsername() : ""
    }
    
    func loginAndTryAgain() -> Void {
        Alerts.shared.show(text: Texts.shared.getText(key: "pleaseWait"))
        if let user = AppData.shared.getUser() {
            let loginValue = user.loginMethod == "email" ? user.email : user.username
            RestClient.client.login(loginMethod: user.loginMethod, loginValue: loginValue, password: user.password, completionHandler: { (user, errorString) in
                if errorString != nil {
                    AppData.shared.logOutUser()
                    if (AppData.shared.getUsers().count > 0) {
                        let user = AppData.shared.getUser()
                        self.navigationItem.title = user != nil ? user!.presentableFullUsername() : ""
                        self.loginAndTryAgain()
                    } else {
                        self.segueToLoginWithoutRemovingOverlay()
                    }
                    return
                }
                self.loadGames()
            })
        }
    }
    
    @objc func loadFromRefresh() {
        Alerts.shared.refreshSpinnerShown(refreshControl: customRefresh)
        loadGames()
    }
    
    @objc func loadGames() {
        
        if (AppData.shared.getUser() == nil) {
            return
        }
        
        Alerts.shared.show(text: Texts.shared.getText(key: "pleaseWait"))
        RestClient.client.getGames(completionHandler: { (games, errorString) in
            if let errorString = errorString {
                // got an error in getting the data, need to handle it
                print("error calling POST for Games")
                if errorString == "login_required" {
                    self.loginAndTryAgain()
                    return
                }
                Alerts.shared.alert(view: self, title: Texts.shared.getText(key: "loadingFailed"), errorString: errorString)
                return
            }
            guard let games = games else {
                print("error getting games: result is nil")
                return
            }
            // success :)
            self.games = self.orderGamesByStatus(games: self.keepTiles(games: games))
            
            //hente bilder for alle spillere:
            var opponentInfo = [UInt64:Double]()
            for game in games {
                let avatar = AppData.shared.getAvatar(id: game.opponent.id)
                if (avatar == nil || (game.opponent.avatar_updated != nil && avatar!.updated != game.opponent.avatar_updated!)) {
                    opponentInfo[game.opponent.id] = game.opponent.avatar_updated
                }
            }
            
            //henter bilder
            let avatarTaskGroup = DispatchGroup()
            let avatarRoot = AppData.shared.getUser()?.avatarRoot
            //for opponentId in opponentIds {
            for opponentId in opponentInfo.keys {
                
                avatarTaskGroup.enter()
                RestClient.client.getAvatar(playerId: opponentId, avatarRoot: avatarRoot, completionHandler: { (avatar_data, error) in
                    if let error = error {
                        // got an error in getting the data, need to handle it
                        print("error calling GET for avatar")
                        print(error)
                        return
                    }
                    guard let avatar_data = avatar_data else {
                        print("error getting avatar: result is nil")
                        return
                    }
                    // success :)
                    AppData.shared.addAvatar(id: opponentId, avatar: Avatar(image: UIImage(data: avatar_data) ?? UIImage(named: "black_circle")!, updated: opponentInfo[opponentId]!, lastShown: Date()))
                    
                    for section in 0 ..< self.games.count {
                        for row in 0 ..< self.games[section].count {
                            if self.games[section][row].opponent.id == opponentId {
                                DispatchQueue.main.async(execute: {
                                    //perform all UI stuff here
                                    self.tableView.reloadRows(at: [IndexPath(item: row, section: section)], with: UITableView.RowAnimation.none)
                                })
                            }
                        }
                    }
                    
                    avatarTaskGroup.leave()
                })
                
            }
            //ferdig med å hente bilder
            avatarTaskGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                Alerts.shared.hide()
            }))
            
            DispatchQueue.main.async(execute: {
                //perform all UI stuff here
                self.tableView.reloadData()
            })
        })
    }
    
    private func keepTiles(games: [Game]) -> [Game] {
        let storedGames = AppData.shared.getGames()
        for game in games {
            if let gameWithLetterCount = storedGames.first(where: { $0.id == game.id }) {
                if game.updated == gameWithLetterCount.updated {
                    game.letterCount = gameWithLetterCount.letterCount
                }
            }
        }
        AppData.shared.setGames(games: games)
        return games
    }
    
    private func orderGamesByStatus(games: [Game]) ->  [[Game]] {
        var ordered = Array(repeating: [Game](), count: 3)
        for game in games {
            if !game.isRunning {
                ordered[2].append(game)
            } else {
                if game.playersTurn {
                    ordered[0].append(game)
                } else {
                    ordered[1].append(game)
                }
            }
        }
        return ordered
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadGames()
        
        NotificationCenter.default.addObserver(self, selector:#selector(loadGames), name:UIApplication.didBecomeActiveNotification, object:UIApplication.shared
        )
        NotificationCenter.default.addObserver(self, selector: #selector(segueToLogin), name: NSNotification.Name("ShowLogin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchUser), name: NSNotification.Name("ShowUser"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (AppData.shared.getUser() == nil) {
            segueToLoginWithoutAnimation()
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (AppData.shared.getUser() == nil) {
            return
        }
        
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        
        customRefresh = UIRefreshControl()
        customRefresh.addTarget(self, action: #selector(loadFromRefresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(customRefresh)
        customRefresh.layer.zPosition = -1
        
        games = orderGamesByStatus(games: AppData.shared.getGames())
        
        languagesButton.setTitle("  \u{2699}\u{0000FE0E} ", for: .normal)
        languagesButton.titleLabel?.font = languagesButton.titleLabel?.font.withSize(30)
        
        let user = AppData.shared.getUser()
        self.navigationItem.title = user != nil ? user!.presentableFullUsername() : ""
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        loadTexts()
    }
    
    func loadTexts() {
        customRefresh.attributedTitle = NSAttributedString(string: Texts.shared.getText(key: "pleaseWait"))
        logoutButton.title = Texts.shared.getText(key: "logout")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.tableView.reloadData()
        })
        overlay.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        overlay.setNeedsDisplay()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GameTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        // Fetches the appropriate game for the data source layout.
        let game = games[indexPath.section][indexPath.row]
        
        let avatar = AppData.shared.getAvatar(id: game.opponent.id)
        cell.opponentImageView.image = avatar != nil ? avatar!.image : nil
        
        let boldAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        cell.opponentLabel.attributedText = NSMutableAttributedString(string: game.opponent.presentableUsername(), attributes: boldAttributes)
        
        cell.languageLabel.text = Texts.shared.getGameLanguage(ruleset: game.ruleset)
        cell.scoreLabel.text = "\(game.player.score) - \(game.opponent.score)"
        cell.lastMoveLabel.text = game.getLastMoveText();
        cell.addDiffLabel(myScore: game.player.score, opponentScore: game.opponent.score)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "TableHeaderCell") as! TableHeaderCell
        if section == 0 {
            header.headerLabel.text = Texts.shared.getText(key: "yourTurn")
        } else if section == 1 {
            header.headerLabel.text = Texts.shared.getText(key: "opponentsTurn")
        } else {
            header.headerLabel.text = Texts.shared.getText(key: "finishedGames")
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return games[section].count > 0 ? 50 : 0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "languagePopover" {
            let destination = segue.destination
            if let popover = destination.popoverPresentationController {
                popover.delegate = self
            }
        } else {
            // Get the new view controller using segue.destinationViewController.
            guard let destination = segue.destination as? GameCollectionViewController,
                let gameIndexPath = tableView.indexPathForSelectedRow else {
                    return
            }
            // Pass the selected object to the new view controller.
            destination.setGame(game: games[gameIndexPath.section][gameIndexPath.row])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func languagePopover(_ sender: Any) {        
        self.performSegue(withIdentifier: "languagePopover", sender: self)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func segueToLoginWithoutAnimation() {
        self.performSegue(withIdentifier: "NoAnimationSegue", sender: nil)
    }
    
    func segueToLoginWithoutRemovingOverlay() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "RightToLeftSegue", sender: nil)
        })
    }
    
    @objc func segueToLogin() {
        removeOverlay()
        performSegue(withIdentifier: "RightToLeftSegue", sender: nil)
    }
}
