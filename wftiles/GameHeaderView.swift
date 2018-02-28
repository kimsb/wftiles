//
//  GameHeaderView.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 10/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class GameHeaderView: UICollectionReusableView {
    
    //MARK: Variables
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    private var diffLabel: UILabel?

    func addDiffLabel(myScore: Int, opponentScore: Int) {
        if diffLabel != nil {
            diffLabel!.removeFromSuperview()
        }
        diffLabel = DiffLabel(maxX: avatarImageView.frame.maxX, minY: avatarImageView.frame.minY).withDiff(yourScore: myScore, opponentScore: opponentScore)
        addSubview(diffLabel!)
    }
    
}
