//
//  Game.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Game: NSObject, NSCoding {
    let id: UInt64
    var letterCount: [String:Int]
    let isRunning: Bool
    var opponent: Player
    let player: Player
    let lastMove: Move?
    let ruleset: Int
    let playersTurn: Bool
    let updated: UInt64
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("game")
    
    struct PropertyKey {
        static let id = "id"
        static let letterCount = "letterCount"
        static let isRunning = "isRunning"
        static let opponent = "opponent"
        static let player = "player"
        static let lastMove = "lastMove"
        static let ruleset = "ruleset"
        static let playersTurn = "playersTurn"
        static let updated = "updated"
    }
    
    init(id: UInt64, letterCount: [String:Int], isRunning: Bool, opponent: Player, player: Player, lastMove: Move?, ruleset: Int, playersTurn: Bool, updated: UInt64) {
        self.id = id
        self.letterCount = letterCount
        self.isRunning = isRunning
        self.opponent = opponent
        self.player = player
        self.lastMove = lastMove
        self.ruleset = ruleset
        self.playersTurn = playersTurn
        self.updated = updated
        if Texts.shared.unsupportedLanguage(ruleset: ruleset) {
            self.letterCount = [String:Int]()
            self.player.rack = []
        }
    }
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(letterCount, forKey: PropertyKey.letterCount)
        aCoder.encode(isRunning, forKey: PropertyKey.isRunning)
        aCoder.encode(opponent, forKey: PropertyKey.opponent)
        aCoder.encode(player, forKey: PropertyKey.player)
        aCoder.encode(lastMove, forKey: PropertyKey.lastMove)
        aCoder.encode(ruleset, forKey: PropertyKey.ruleset)
        aCoder.encode(playersTurn, forKey: PropertyKey.playersTurn)
        aCoder.encode(updated, forKey: PropertyKey.updated)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: PropertyKey.id) as! UInt64
        let letterCount = aDecoder.decodeObject(forKey: PropertyKey.letterCount) as! [String:Int]
        let isRunning = Bool(aDecoder.decodeBool(forKey: PropertyKey.isRunning))
        let opponent = aDecoder.decodeObject(forKey: PropertyKey.opponent) as! Player
        let player = aDecoder.decodeObject(forKey: PropertyKey.player) as! Player
        let lastMove = aDecoder.decodeObject(forKey: PropertyKey.lastMove) as? Move
        let ruleset = aDecoder.decodeInteger(forKey: PropertyKey.ruleset)
        let playersTurn = Bool(aDecoder.decodeBool(forKey: PropertyKey.playersTurn))
        let updated = aDecoder.decodeObject(forKey: PropertyKey.updated) as! UInt64
        
        self.init(id: id, letterCount: letterCount, isRunning: isRunning, opponent: opponent, player: player, lastMove: lastMove, ruleset: ruleset, playersTurn: playersTurn, updated: updated)
    }
    
    func getRemainingLetters() -> [String] {
        if letterCount.isEmpty {
            return []
        }
        var sortedRemainingLetters = [String]()
        for letter in Constants.tiles.letters(ruleset: ruleset) {
            for _ in 0..<letterCount[letter]! {
                sortedRemainingLetters.append(letter)
            }
        }
        return sortedRemainingLetters
    }
    
    func getLastMoveText() -> String {
        let opponentName = opponent.presentableUsername()
        guard let lastMove = lastMove else {
            if playersTurn {
                return String(format: Texts.shared.getText(key: "firstMoveYou"), opponentName)
            } else {
                return String(format: Texts.shared.getText(key: "firstMoveThem"), opponentName)
            }
        }
        switch lastMove.move_type {
        case "move":
            if lastMove.user_id == AppData.shared.getUser()!.id {
                return String(format: Texts.shared.getText(key: "youPlayed"), lastMove.main_word!, lastMove.points!)
            } else {
                return String(format: Texts.shared.getText(key: "theyPlayed"), opponentName, lastMove.main_word!, lastMove.points!)
            }
        case "pass":
            if lastMove.user_id == AppData.shared.getUser()!.id  {
                return Texts.shared.getText(key: "youPassed")
            } else {
                return String(format: Texts.shared.getText(key: "theyPassed"), opponentName)
                
            }
        case "swap":
            if lastMove.user_id == AppData.shared.getUser()!.id  {
                if (lastMove.tile_count! == 1) {
                    return String(format: Texts.shared.getText(key: "youSwappedOne"), lastMove.tile_count!)
                }
                return String(format: Texts.shared.getText(key: "youSwapped"), lastMove.tile_count!)
            } else {
                if (lastMove.tile_count! == 1) {
                    return String(format: Texts.shared.getText(key: "theySwappedOne"), opponentName, lastMove.tile_count!)
                }
                return String(format: Texts.shared.getText(key: "theySwapped"), opponentName, lastMove.tile_count!)
            }
        case "resign":
            if lastMove.user_id == AppData.shared.getUser()!.id  {
                return Texts.shared.getText(key: "youResigned")
            } else {
                return String(format: Texts.shared.getText(key: "theyResigned"), opponentName)
            }
        default:
            return ""
        }
    }
}
