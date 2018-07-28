//
//  LanguageController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/07/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class LanguageController: UITableViewController {
    
    private let languageKeys = ["englishLanguage", "norwegianLanguage", "dutchLanguage", "danishLanguage", "swedishLanguage", "spanishLanguage", "frenchLanguage", "germanLanguage", "finnishLanguage", "portugueseLanguage"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "LanguageViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LanguageViewCell  else {
            fatalError("The dequeued cell is not an instance of LanguageViewCell.")
        }
        let language = Texts.shared.getText(key: languageKeys[indexPath.row])
        
        if indexPath.row == Texts.shared.getLocaleIndex() {
            cell.accessoryType = .checkmark
        }
        
        cell.language.text = language
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "LanguageHeaderCell") as! LanguageHeaderCell
        if section == 0 {
            header.headerLabel.text = Texts.shared.getText(key: "language")
        }
        header.backgroundColor = UIColor.white
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        tableView.cellForRow(at: IndexPath(row: Texts.shared.getLocaleIndex(), section: 0))?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        AppData.shared.setPreferredLanguageIndex(languageIndex: indexPath.row)
        
        let gameTableViewController = popoverPresentationController!.delegate as! GameTableViewController
        gameTableViewController.tableView.reloadData()
        gameTableViewController.loadTexts()
    }
    
}
