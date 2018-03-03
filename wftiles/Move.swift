//
//  Move.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Move: NSObject, Codable, NSCoding {
    let points: Int?
    let move_type: String
    let user_id: UInt64
    let main_word: String?
    let tile_count: Int?
    
    struct PropertyKey {
        static let points = "points"
        static let move_type = "move_type"
        static let user_id = "user_id"
        static let main_word = "main_word"
        static let tile_count = "tile_count"
    }
    
    init(points: Int?, move_type: String, user_id: UInt64, main_word: String?, tile_count: Int?) {
        self.points = points
        self.move_type = move_type
        self.user_id = user_id
        self.main_word = main_word
        self.tile_count = tile_count
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(points, forKey: PropertyKey.points)
        aCoder.encode(move_type, forKey: PropertyKey.move_type)
        aCoder.encode(user_id, forKey: PropertyKey.user_id)
        aCoder.encode(main_word, forKey: PropertyKey.main_word)
        aCoder.encode(tile_count, forKey: PropertyKey.tile_count)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let points = aDecoder.decodeObject(forKey: PropertyKey.points) as? Int
        let move_type = aDecoder.decodeObject(forKey: PropertyKey.move_type) as! String
        let user_id = aDecoder.decodeObject(forKey: PropertyKey.user_id) as! UInt64
        let main_word = aDecoder.decodeObject(forKey: PropertyKey.main_word) as? String
        let tile_count = aDecoder.decodeObject(forKey: PropertyKey.tile_count) as? Int

        self.init(points: points, move_type: move_type, user_id: user_id, main_word: main_word, tile_count: tile_count)
    }
}
