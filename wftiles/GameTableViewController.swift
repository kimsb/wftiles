//
//  GameTableViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 26/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController {
    //MARK: Properties
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var games = Array(repeating: [Game](), count: 3)
    
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
                self.loadGames()
            })
        }
    }
    
    @objc func loadGames() {
        Alerts.shared.show(text: Texts.shared.getText(key: "pleaseWait"))
        let games = RestClient.client.getGames(completionHandler: { (games, errorString) in
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
            var opponentInfo = [UInt64:UInt64]()
            for game in games {
                if (AppData.shared.getAvatar(id: game.opponent.id) == nil || AppData.shared.getAvatar(id: game.opponent.id)!.updated != game.opponent.avatar_updated!) {
                    opponentInfo[game.opponent.id] = game.opponent.avatar_updated
                }
            }
            
            //henter bilder
            let avatarTaskGroup = DispatchGroup()
            //for opponentId in opponentIds {
            for opponentId in opponentInfo.keys {
                
                avatarTaskGroup.enter()
                let avatar_data = RestClient.client.getAvatar(opponentId: opponentId, completionHandler: { (avatar_data, error) in
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
                    AppData.shared.addAvatar(id: opponentId, avatar: Avatar(image: UIImage(data: avatar_data)!, updated: opponentInfo[opponentId]!, lastShown: Date()))
                    
                    for section in 0 ..< self.games.count {
                        for row in 0 ..< self.games[section].count {
                            if self.games[section][row].opponent.id == opponentId {
                                DispatchQueue.main.async(execute: {
                                    //perform all UI stuff here
                                    self.tableView.reloadRows(at: [IndexPath(item: row, section: section)], with: UITableViewRowAnimation.none)
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
                game.letterCount = gameWithLetterCount.letterCount
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
            NotificationCenter.default.addObserver(self, selector:#selector(loadGames), name:NSNotification.Name.UIApplicationDidBecomeActive, object:UIApplication.shared
            )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        games = orderGamesByStatus(games: AppData.shared.getGames())
        
        logoutButton.title = Texts.shared.getText(key: "logout")
        
        self.navigationItem.title = AppData.shared.getUser()!.username
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButton

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if let avatar = AppData.shared.getAvatar(id: game.opponent.id) {
            cell.opponentImageView.image = avatar.image
        } else {
            cell.opponentImageView.image = nil
        }
        
        cell.opponentLabel.text = game.opponent.username
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
        header.backgroundColor = UIColor.white
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return games[section].count > 0 ? 50 : 0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        guard let destination = segue.destination as? GameCollectionViewController,
            let gameIndexPath = tableView.indexPathForSelectedRow else {
                return
        }
        // Pass the selected object to the new view controller.
        destination.game = games[gameIndexPath.section][gameIndexPath.row]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
}
