//
//  Avatars.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 29/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Avatars {
    
    struct Avatar {
        let data: Data
        let updated: UInt64
    }
    
    var cache = [UInt64:Avatar]()
    
    static let store = Avatars()
    
    private init() {
    }
}
