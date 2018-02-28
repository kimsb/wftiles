//
//  RightToLeftSegue.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 28/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class RightToLeftSegue : UIStoryboardSegue {
    
    override func perform() {
        source.navigationController?.viewControllers = [destination, source]
        source.navigationController?.popViewController(animated: true)
    }
    
}
