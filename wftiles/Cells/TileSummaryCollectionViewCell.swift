//
//  TileSummaryCollectionViewCell.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 14/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class TileSummaryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tileView: UIView!
    @IBOutlet weak var tileLetterLabel: UILabel!
    @IBOutlet weak var tileScoreLabel: UILabel!
    @IBOutlet weak var letterCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
