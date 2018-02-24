//
//  Move.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

struct Move: Decodable {
    let points: Int?
    let move_type: String
    let user_id: UInt64
    let main_word: String?
    let tile_count: Int?
}
