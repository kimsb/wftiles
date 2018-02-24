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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
