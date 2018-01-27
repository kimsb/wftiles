//
//  Player.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

struct Player: Decodable {
    let username: String
    let score: Int
    let id: UInt64
    let rack: [String]?
    var avatar: Data?
    
    /*init(username: String, score: Int, id: UInt64, rack: [String]?) {
        self.username = username
        self.score = score
        self.id = id
        self.rack = rack
    }*/
}
