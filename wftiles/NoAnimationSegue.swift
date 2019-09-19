//
//  NoAnimationSegue.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 19/09/2019.
//  Copyright © 2019 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class NoAnimationSegue : UIStoryboardSegue {
    
    override func perform() {
        source.navigationController?.viewControllers = [destination, source]
        source.navigationController?.popViewController(animated: false)
    }
    
}
