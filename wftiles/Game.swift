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
    let updated: UInt64
    
    func getLastMoveText() -> String {
        guard let lastMove = lastMove else {
            if playersTurn {
                return Texts.shared.getText(key: "firstMoveYou")
            } else {
                return Texts.shared.getText(key: "firstMoveThem")
            }
        }
        switch lastMove.move_type {
        case "move":
            if lastMove.user_id == AppData.store.getUser()!.id {
                return String(format: Texts.shared.getText(key: "youPlayed"), lastMove.main_word!, lastMove.points!)
            } else {
                return String(format: Texts.shared.getText(key: "theyPlayed"), opponent.username, lastMove.main_word!, lastMove.points!)
            }
        case "pass":
            if lastMove.user_id == AppData.store.getUser()!.id  {
                return Texts.shared.getText(key: "youPassed")
            } else {
                return String(format: Texts.shared.getText(key: "theyPassed"), opponent.username)
                
            }
        case "swap":
            if lastMove.user_id == AppData.store.getUser()!.id  {
                if (lastMove.tile_count! == 1) {
                    return String(format: Texts.shared.getText(key: "youSwappedOne"), lastMove.tile_count!)
                }
                return String(format: Texts.shared.getText(key: "youSwapped"), lastMove.tile_count!)
            } else {
                if (lastMove.tile_count! == 1) {
                    return String(format: Texts.shared.getText(key: "theySwappedOne"), opponent.username, lastMove.tile_count!)
                }
                return String(format: Texts.shared.getText(key: "theySwapped"), opponent.username, lastMove.tile_count!)
            }
        case "resign":
            if lastMove.user_id == AppData.store.getUser()!.id  {
                return Texts.shared.getText(key: "youResigned")
            } else {
                return String(format: Texts.shared.getText(key: "theyResigned"), opponent.username)
            }
        default:
            return ""
        }
    }
}
