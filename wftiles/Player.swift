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
    let avatar_updated: Double?
    let fb_first_name: String?
    let fb_middle_name: String?
    let fb_last_name: String?
    
    struct PropertyKey {
        static let username = "username"
        static let score = "score"
        static let id = "id"
        static let rack = "rack"
        static let avatar_updated = "avatar_updated"
        static let fb_first_name = "fb_first_name"
        static let fb_middle_name = "fb_middle_name"
        static let fb_last_name = "fb_last_name"
    }
    
    init(username: String, score: Int, id: UInt64, rack: [String]?, avatar_updated: Double?, fb_first_name: String?, fb_middle_name: String?, fb_last_name: String?) {
        self.username = username
        self.score = score
        self.id = id
        self.rack = rack
        self.avatar_updated = avatar_updated
        self.fb_first_name = fb_first_name
        self.fb_middle_name = fb_middle_name
        self.fb_last_name = fb_last_name
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(score, forKey: PropertyKey.score)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(rack, forKey: PropertyKey.rack)
        aCoder.encode(avatar_updated, forKey: PropertyKey.avatar_updated)
        aCoder.encode(fb_first_name, forKey: PropertyKey.fb_first_name)
        aCoder.encode(fb_middle_name, forKey: PropertyKey.fb_middle_name)
        aCoder.encode(fb_last_name, forKey: PropertyKey.fb_last_name)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: PropertyKey.username) as! String
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        let id = aDecoder.decodeObject(forKey: PropertyKey.id) as! UInt64
        let rack = aDecoder.decodeObject(forKey: PropertyKey.rack) as? [String]
        let avatar_updated = aDecoder.decodeObject(forKey: PropertyKey.avatar_updated) as? Double
        let fb_first_name = aDecoder.decodeObject(forKey: PropertyKey.fb_first_name) as? String
        let fb_middle_name = aDecoder.decodeObject(forKey: PropertyKey.fb_middle_name) as? String
        let fb_last_name = aDecoder.decodeObject(forKey: PropertyKey.fb_last_name) as? String
        
        self.init(username: username, score: score, id: id, rack: rack, avatar_updated: avatar_updated, fb_first_name: fb_first_name, fb_middle_name: fb_middle_name, fb_last_name: fb_last_name)
    }
    
    func presentableUsername() -> String {
        if username.hasPrefix("_fb_") && !(fb_first_name ?? "").isEmpty {
            return fb_first_name!
        }
        return username
    }
}
