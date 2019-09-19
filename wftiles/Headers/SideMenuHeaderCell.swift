//
//  SideMenuHeaderCell.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 12/09/2019.
//  Copyright © 2019 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class SideMenuHeaderCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    private let lightGrey = UIColor(red: CGFloat(247/255.0), green: CGFloat(247/255.0), blue: CGFloat(247/255.0), alpha: CGFloat(1.0))
    private let darkGrey = UIColor(red: CGFloat(222/255.0), green: CGFloat(222/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradient = CAGradientLayer()
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradient.frame = bounds
        gradient.colors = [darkGrey.cgColor, lightGrey.cgColor]
        //gradient.anchorPoint = CGPoint.zero
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    
}
