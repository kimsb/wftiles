//
//  PopoverController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 15/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class PopoverController: UIViewController {
    
    @IBOutlet weak var viewSegmentedController: UISegmentedControl!
    @IBOutlet weak var sortSegmentedController: UISegmentedControl!
    
    @IBAction func viewSegmentedControllerChangedValue(_ sender: Any) {
        AppData.store.setShowSummary(showSummary: viewSegmentedController.selectedSegmentIndex == 1)
        let gameCollectionViewController = popoverPresentationController!.delegate as! GameCollectionViewController
        gameCollectionViewController.viewSwitchChangedValue()
    }

    @IBAction func sortSegmentedControllerChangedValue(_ sender: Any) {
        AppData.store.setSortByVowels(sortByVowels: sortSegmentedController.selectedSegmentIndex == 1)
        let gameCollectionViewController = popoverPresentationController!.delegate as! GameCollectionViewController
        gameCollectionViewController.sortSwitchChangedValue()
    }
    
    override func viewDidLoad() {
        if AppData.store.showSummary() {
            viewSegmentedController.selectedSegmentIndex = 1
        } else {
            viewSegmentedController.selectedSegmentIndex = 0
        }
        if AppData.store.sortByVowels() {
            sortSegmentedController.selectedSegmentIndex = 1
        } else {
            sortSegmentedController.selectedSegmentIndex = 0
        }
    }
    
}
