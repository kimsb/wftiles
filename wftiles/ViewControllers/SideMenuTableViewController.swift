//
//  SideMenuTableViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 12/09/2019.
//  Copyright © 2019 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(AppData.shared.getUsers().count - 1, 0) + 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
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
        
        let users = AppData.shared.getUsers()
        
        if (indexPath.row < users.count) {
        cell.userAvatar.image = users[indexPath.row].avatar?.image ?? UIImage(named: "black_circle")!
        cell.usernameLabel.text = users[indexPath.row].username
        } else {
            cell.userAvatar.image = UIImage(named: "plus_icon")!
            cell.usernameLabel.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0) {
            let header = tableView.dequeueReusableCell(withIdentifier: "SideMenuHeaderCell") as! SideMenuHeaderCell
            header.userAvatar.image = AppData.shared.getUser()?.avatar?.image ?? UIImage(named: "black_circle")!
            header.usernameLabel.text = AppData.shared.getUser()?.username ?? ""
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var statusbarHeight = CGFloat(20)
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            statusbarHeight = topPadding ?? 20
        }
        return 82 + statusbarHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 65 : 52
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            AppData.shared.logOutUser()
            if (AppData.shared.getUsers().count > 0) {
                NotificationCenter.default.post(name: NSNotification.Name("ShowUser"), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("ShowLogin"), object: nil)
            }
        } else if (indexPath.row == AppData.shared.getUsers().count) {
            NotificationCenter.default.post(name: NSNotification.Name("ShowLogin"), object: nil)
        } else {
            AppData.shared.switchToUserAtIndex(index: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name("ShowUser"), object: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.tableView.reloadData()
        })
    }
}
