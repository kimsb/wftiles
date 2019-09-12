//
//  SideMenuLogoutCell.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 12/09/2019.
//  Copyright © 2019 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class SideMenuLogoutCell: UITableViewCell {
    
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*let holdingView = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view!
        let maxSize = holdingView.frame.size.height > holdingView.frame.size.width
            ? holdingView.frame.size.height : holdingView.frame.size.width*/
        
        let footerSeparator = UIView();
        footerSeparator.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: 240, height: 1)
        footerSeparator.backgroundColor = UIColor(white:224.0/255.0, alpha:1.0)
        self.addSubview(footerSeparator)
    }
    
}
