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
    let opponent: Player
    let player: Player
    let lastMove: Move
    
    /*init(id: UInt64, usedLetters: [String], isRunning: Bool, bagCount: Int, opponent: Player, player: Player, lastMove: Move) {
        self.id = id
        self.usedLetters = usedLetters
        self.isRunning = isRunning
        self.bagCount = bagCount
        self.opponent = opponent
        self.player = player
        self.lastMove = lastMove
    }*/
}
