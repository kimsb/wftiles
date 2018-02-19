//
//  TableHeaderCell.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 13/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class TableHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let headerSeparator = UIView();
        headerSeparator.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
        headerSeparator.backgroundColor = UIColor(white:224.0/255.0, alpha:1.0)
        self.addSubview(headerSeparator)
        let footerSeparator = UIView();
        footerSeparator.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        footerSeparator.backgroundColor = UIColor(white:224.0/255.0, alpha:1.0)
        self.addSubview(footerSeparator)
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

}
