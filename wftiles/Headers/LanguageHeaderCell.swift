//
//  LanguageHeaderCell.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/07/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class LanguageHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let footerSeparator = UIView();
        footerSeparator.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: 290, height: 1)
        footerSeparator.backgroundColor = UIColor(white:224.0/255.0, alpha:1.0)
        self.addSubview(footerSeparator)
    }
}
