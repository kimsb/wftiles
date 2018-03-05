//
//  GameTableViewCell.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 26/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    @IBOutlet weak var opponentImageView: UIImageView!
    private var diffLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if diffLabel == nil {
            super.setSelected(selected, animated: animated)
            return
        }
        let backgroundColor = diffLabel!.backgroundColor
        super.setSelected(selected, animated: animated)
        diffLabel!.backgroundColor = backgroundColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if diffLabel == nil {
            super.setHighlighted(highlighted, animated: animated)
            return
        }
        let backgroundColor = diffLabel!.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        diffLabel!.backgroundColor = backgroundColor
    }
    
    func addDiffLabel(myScore: Int, opponentScore: Int) {
        if diffLabel != nil {
            diffLabel!.removeFromSuperview()
        }
        diffLabel = DiffLabel(maxX: opponentImageView.frame.maxX, minY: opponentImageView.frame.minY).withDiff(yourScore: myScore, opponentScore: opponentScore)
        addSubview(diffLabel!)
    }

}
