//
//  SideMenuTableViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 12/09/2019.
//  Copyright © 2019 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    let userCount:Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : userCount + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellIdentifier = "SideMenuLogoutCell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideMenuLogoutCell  else {
                fatalError("The dequeued cell is not an instance of SideMenuLogoutCell.")
            }
            cell.logoutLabel.text = Texts.shared.getText(key: "logout")
            return cell
        }
        
        let cellIdentifier = "SideMenuUserCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SideMenuUserCell  else {
            fatalError("The dequeued cell is not an instance of SideMenuUserCell.")
        }
        // Fetches the appropriate game for the data source layout.
        /*let game = games[indexPath.section][indexPath.row]
         
         let avatar = AppData.shared.getAvatar(id: game.opponent.id)
         cell.opponentImageView.image = avatar != nil ? avatar!.image : nil
         
         let boldAttributes = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
         cell.opponentLabel.attributedText = NSMutableAttributedString(string: game.opponent.presentableUsername(), attributes: boldAttributes)
         
         cell.languageLabel.text = Texts.shared.getGameLanguage(ruleset: game.ruleset)
         cell.scoreLabel.text = "\(game.player.score) - \(game.opponent.score)"
         cell.lastMoveLabel.text = game.getLastMoveText();
         cell.addDiffLabel(myScore: game.player.score, opponentScore: game.opponent.score)*/
        
        if (indexPath.row < userCount) {
        cell.userAvatar.image = AppData.shared.getAvatar(id: AppData.shared.getGames()[0].opponent.id)!.image
        cell.usernameLabel.text = "player #\(indexPath.row)"
        } else {
            cell.userAvatar.image = UIImage(named: "plus_icon")!
            cell.usernameLabel.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0) {
            let header = tableView.dequeueReusableCell(withIdentifier: "SideMenuHeaderCell") as! SideMenuHeaderCell
            header.userAvatar.image = AppData.shared.getAvatar(id: AppData.shared.getGames()[0].opponent.id)!.image
            header.usernameLabel.text = "Pålogget bruker"
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 82 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 50 : 44
    }
    
}
