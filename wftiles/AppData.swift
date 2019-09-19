//
//  AppData.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 29/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class AppData {
    
    static let shared = AppData()
    
    func getAvatar(id: UInt64) -> Avatar? {
        if avatars[id] != nil {
            avatars[id]!.lastShown = Date()
        }
        return avatars[id]
    }
    
    func addAvatar(id: UInt64, avatar: Avatar) {
        if avatars.count > 99 {
            let longestTimeSinceShown = avatars.values.min { $0.lastShown < $1.lastShown }
            avatars = avatars.filter {$0.value.lastShown != longestTimeSinceShown!.lastShown}
        }
        avatars[id] = avatar
        saveAvatars()
    }
    
    func getLastAttemptedLogin() -> User? {
        return lastAttemptedLogin
    }
    
    func getUser() -> User? {
        return users.first
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func switchToUserAtIndex(index: Int) {
        addUser(user: users[index])
    }
    
    func addUser(user: User) {
        users = users.filter {$0.username != user.username}
        users.insert(user, at: 0)
        saveUsers()
        lastAttemptedLogin = nil
    }
    
    func logOutUser() {
        
        print("logger ut: nå er det: \(users.count) brukere")
        
        if (!users.isEmpty) {
            let removed = users.removeFirst()
            saveUsers()
            if (users.isEmpty) {
                lastAttemptedLogin = removed
            }
        }
        
        print("logget ut: nå er det: \(users.count) brukere")
    }
    
    func showSummary() -> Bool {
        guard let preferences = preferences else {
            return false
        }
        return preferences.showSummary
    }
    
    func setShowSummary(showSummary: Bool) {
        preferences = Preferences(showSummary: showSummary, sortByVowels: sortByVowels(), languageIndex: preferredLanguageIndex())
        savePreferences()
    }
    
    func sortByVowels() -> Bool {
        guard let preferences = preferences else {
            return false
        }
        return preferences.sortByVowels
    }
    
    func setSortByVowels(sortByVowels: Bool) {
        preferences = Preferences(showSummary: showSummary(), sortByVowels: sortByVowels, languageIndex: preferredLanguageIndex())
        savePreferences()
    }
    
    func preferredLanguageIndex() -> Int? {
        guard let preferences = preferences else {
            return nil
        }
        return preferences.languageIndex
    }
    
    func setPreferredLanguageIndex(languageIndex: Int) {
        preferences = Preferences(showSummary: showSummary(), sortByVowels: sortByVowels(), languageIndex: languageIndex)
        savePreferences()
    }
    
    func getGames() -> [Game] {
        guard let user = getUser() else {
            print("return 1")
            return []
        }
        guard let usersGames = games[user.id] else {
            print("return 2")
            return []
        }
        print("return 3")
        return usersGames
    }
    
    func setGames(games: [Game]) {
        
        print("setter \(games.count) games for user: \(getUser()!.username)")
        
        if let user = getUser() {
            self.games[user.id] = games
            saveGames()
        }
    }
    
    func setGameWithUsedLetters(game: Game) {
        var usersGames = getGames()
        if let index = usersGames.index(where: { $0.id == game.id}) {
            usersGames[index] = game
            saveGames()
        }
    }
    
    private var preferences: Preferences?
    private var avatars: [UInt64:Avatar]
    private var games: [UInt64:[Game]]
    private var users: [User]
    private var lastAttemptedLogin: User?
    
    private func savePreferences() {
        NSKeyedArchiver.archiveRootObject(preferences!, toFile: Preferences.ArchiveURL.path)
    }
    
    private func saveUsers() {
        NSKeyedArchiver.archiveRootObject(users, toFile: User.ArchiveURL.path)
    }
    
    private func saveAvatars() {
        NSKeyedArchiver.archiveRootObject(avatars, toFile: Avatar.ArchiveURL.path)
    }
    
    private func saveGames() {
        NSKeyedArchiver.archiveRootObject(games, toFile: Game.ArchiveURL.path)
    }
    
    private init() {
        preferences = NSKeyedUnarchiver.unarchiveObject(withFile: Preferences.ArchiveURL.path) as? Preferences
        
        if let loadedUsers = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User] {
            users = loadedUsers
        } else {
            users = []
            if let user = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User {
                users.append(user)
            }
        }
        
        if let loadedAvatars = NSKeyedUnarchiver.unarchiveObject(withFile: Avatar.ArchiveURL.path) as? [UInt64:Avatar] {
            avatars = loadedAvatars
        } else {
            avatars = [UInt64:Avatar]()
        }
        
        if let loadedGames = NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL.path) as? [UInt64:[Game]] {
            games = loadedGames
        } else {
            games = [UInt64:[Game]]()
            if let gamesArray = NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL.path) as? [Game] {
                if let user = getUser() {
                    games[user.id] = gamesArray
                }
            }
        }
    }
    
}
