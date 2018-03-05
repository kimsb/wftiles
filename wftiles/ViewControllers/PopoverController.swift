//
//  PopoverController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 15/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class PopoverController: UIViewController {
    
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var viewSegmentedController: UISegmentedControl!
    @IBOutlet weak var sortSegmentedController: UISegmentedControl!
    
    @IBAction func viewSegmentedControllerChangedValue(_ sender: Any) {
        AppData.shared.setShowSummary(showSummary: viewSegmentedController.selectedSegmentIndex == 1)
        let gameCollectionViewController = popoverPresentationController!.delegate as! GameCollectionViewController
        gameCollectionViewController.viewSwitchChangedValue()
    }

    @IBAction func sortSegmentedControllerChangedValue(_ sender: Any) {
        AppData.shared.setSortByVowels(sortByVowels: sortSegmentedController.selectedSegmentIndex == 1)
        let gameCollectionViewController = popoverPresentationController!.delegate as! GameCollectionViewController
        gameCollectionViewController.sortSwitchChangedValue()
    }
    
    override func viewDidLoad() {
        resizeViewIfNecessary()
        
        let vowelsConsonants = Texts.shared.getText(key: "vowelsConsonants")
        viewSegmentedController.setTitle(Texts.shared.getText(key: "standard"), forSegmentAt: 0)
        viewSegmentedController.setTitle(Texts.shared.getText(key: "overview"), forSegmentAt: 1)
        sortSegmentedController.setTitle(Texts.shared.getText(key: "alphabetical"), forSegmentAt: 0)
        sortSegmentedController.setTitle(vowelsConsonants, forSegmentAt: 1)
        
        let maxFontSize = Texts.shared.getMaxFontSize(text: vowelsConsonants, maxWidth: sortSegmentedController.frame.width/2 - 10)
        viewSegmentedController.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: maxFontSize)], for: .normal)
        sortSegmentedController.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: maxFontSize)], for: .normal)
        
        if AppData.shared.showSummary() {
            viewSegmentedController.selectedSegmentIndex = 1
        } else {
            viewSegmentedController.selectedSegmentIndex = 0
        }
        if AppData.shared.sortByVowels() {
            sortSegmentedController.selectedSegmentIndex = 1
        } else {
            sortSegmentedController.selectedSegmentIndex = 0
        }
    }
    
    func resizeViewIfNecessary() {
        let holdingView = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view!
        if holdingView.frame.size.height <= 320 || holdingView.frame.size.width <= 320 {
            popoverView.frame.size.width = 290
            viewSegmentedController.frame.size.width = 268
            sortSegmentedController.frame.size.width = 268
        }
    }
    
}
