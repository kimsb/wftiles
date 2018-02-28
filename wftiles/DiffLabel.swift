//
//  DiffLabel.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 28/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class DiffLabel {
    
    private let green = UIColor(red: CGFloat(158/255.0), green: CGFloat(229/255.0), blue: CGFloat(178/255.0), alpha: CGFloat(1.0))
    private let red = UIColor(red: CGFloat(224/255.0), green: CGFloat(157/255.0), blue: CGFloat(152/255.0), alpha: CGFloat(1.0))
    private let yellow = UIColor(red: CGFloat(252/255.0), green: CGFloat(240/255.0), blue: CGFloat(151/255.0), alpha: CGFloat(1.0))
    private let maxX: CGFloat
    private let minY: CGFloat
    
    init(maxX: CGFloat, minY: CGFloat) {
        self.maxX = maxX
        self.minY = minY
    }
    
    func withDiff (yourScore: Int, opponentScore: Int) -> UILabel {
        let diff =  yourScore - opponentScore
        let diffText = "\(diff > 0 ? "+" : "")\(diff)"
        let font = UIFont.systemFont(ofSize: CGFloat(13))
        let textWidth = round(Texts.shared.getTextWidth(text: diffText, font: font))
        let labelWidth = textWidth + 8
        
        let diffLabel = UILabel(frame: CGRect(x: maxX - round(labelWidth), y:minY, width:labelWidth, height:20))
        diffLabel.font = font
        diffLabel.text = diffText
        diffLabel.textAlignment = .center
        
        diffLabel.backgroundColor = diff == 0 ? yellow : diff > 0 ? green : red
        
        diffLabel.layer.cornerRadius = 6
        diffLabel.layer.masksToBounds = true
        
        return diffLabel
    }
    
}
