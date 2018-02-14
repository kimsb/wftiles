//
//  Game.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

struct Game {
    let id: UInt64
    let usedLetters: [String]?
    let isRunning: Bool
    let bagCount: Int?
    var opponent: Player
    let player: Player
    let lastMove: Move?
    let ruleset: Int
    let playersTurn: Bool
}
