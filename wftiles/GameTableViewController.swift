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
    var games = [Game]()
    var avatars = [UInt64: Data]()
    
    @objc func loadGames() {
        print("loading games")
        //burde ikke lage ny, men sende fra login via prepare
        let http = RestClient()
        
        print("HENTER GAMES FRA TABLEVIEWCONTROLLER")
        
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
            
            //hente bilder for alle spillere:
            var opponentIds = Set<UInt64>()
            for game in games {
                opponentIds.insert(game.opponent.id)
            }
            
            //henter bilder
            for opponentId in opponentIds {
                if self.avatars[opponentId] == nil {
                    
                    print("DOWNLOADING AVATAR FOR: \(opponentId)")
                    let avatar_data = http.getAvatar(avatar_url: "https://avatars-wordfeud-com.s3.amazonaws.com/60/\(opponentId)", completionHandler: { (avatar_data, error) in
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
                        self.avatars[opponentId] = avatar_data
                        print("FINISHED DOWNLOADING AVATAR FOR: \(opponentId)")
                        for (index, game) in games.enumerated() {
                            if game.opponent.id == opponentId {
                                self.games[index].opponent.avatar = avatar_data
                                DispatchQueue.main.async(execute: {
                                    //perform all UI stuff here
                                    self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableViewRowAnimation.none)
                                })
                            }
                        }
                        
                        
                    })
                }
                
            }
            //ferdig med å hente bilder
            
            self.games = games;
            DispatchQueue.main.async(execute: {
                //perform all UI stuff here
                self.tableView.reloadData()
                
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGames()
        print("GAMETABLEVIEW WILL APPEAR")
        print("registering observer GameView")
        NotificationCenter.default.addObserver(self, selector:#selector(loadGames), name:NSNotification.Name.UIApplicationDidBecomeActive, object:UIApplication.shared
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("GAMETABLEVIEW VIEW DID APPEAR")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GameTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GameTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        // Fetches the appropriate game for the data source layout.
        let game = games[indexPath.row]
        
        //cell.opponentImageView.image = game
        if let avatar = avatars[game.opponent.id] {
            cell.opponentImageView.image = UIImage(data: avatar)
        }
        cell.opponentLabel.text = game.opponent.username
        cell.scoreLabel.text = "(\(game.player.score) - \(game.opponent.score))"
        if let lastMove = game.lastMove {
            cell.lastMoveLabel.text = "Last move: \(lastMove.move_type)"
        } else {
            cell.lastMoveLabel.text = "No moves made"
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        guard let destination = segue.destination as? GameViewController,
            let gameIndex = tableView.indexPathForSelectedRow?.row else {
                print("prepare failed")
                return
        }
        // Pass the selected object to the new view controller.
        
        //dette må fjernes når caching av bilder er implementert
        if games[gameIndex].opponent.avatar == nil {
            games[gameIndex].opponent.avatar = avatars[games[gameIndex].opponent.id]
        }
        
        destination.game = games[gameIndex]
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        print("viewWillDisappear - removing observer")
    }
}
