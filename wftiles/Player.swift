//
//  Player.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Player: NSObject, Codable, NSCoding {
    let username: String
    let score: Int
    let id: UInt64
    var rack: [String]?
    let avatar_updated: UInt64?
    
    struct PropertyKey {
        static let username = "username"
        static let score = "score"
        static let id = "id"
        static let rack = "rack"
        static let avatar_updated = "avatar_updated"
    }
    
    init(username: String, score: Int, id: UInt64, rack: [String]?, avatar_updated: UInt64?) {
        self.username = username
        self.score = score
        self.id = id
        self.rack = rack
        self.avatar_updated = avatar_updated
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(score, forKey: PropertyKey.score)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(rack, forKey: PropertyKey.rack)
        aCoder.encode(avatar_updated, forKey: PropertyKey.avatar_updated)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: PropertyKey.username) as! String
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        let id = aDecoder.decodeObject(forKey: PropertyKey.id) as! UInt64
        let rack = aDecoder.decodeObject(forKey: PropertyKey.rack) as? [String]
        let avatar_updated = aDecoder.decodeObject(forKey: PropertyKey.avatar_updated) as? UInt64
        
        self.init(username: username, score: score, id: id, rack: rack, avatar_updated: avatar_updated)
    }
}
