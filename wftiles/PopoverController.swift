//
//  PopoverController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 15/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class PopoverController: UIViewController {
    
    @IBOutlet weak var viewSwitch: UISwitch!
    @IBOutlet weak var sortSwitch: UISwitch!
    
    @IBAction func viewSwitchChangedValue(_ sender: Any) {
        AppData.store.setShowSummary(showSummary: viewSwitch.isOn)
        let gameCollectionViewController = popoverPresentationController!.delegate as! GameCollectionViewController
        gameCollectionViewController.viewSwitchChangedValue()
    }

    @IBAction func sortSwitchChangedValue(_ sender: Any) {
        AppData.store.setSortByVowels(sortByVowels: sortSwitch.isOn)
        let gameCollectionViewController = popoverPresentationController!.delegate as! GameCollectionViewController
        gameCollectionViewController.sortSwitchChangedValue()
    }
    
    
    override func viewDidLoad() {
        viewSwitch.setOn(AppData.store.showSummary(), animated: false)
        sortSwitch.setOn(AppData.store.sortByVowels(), animated: false)
    }
    
}
