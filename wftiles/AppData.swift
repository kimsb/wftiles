//
//  AppData.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 29/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import os.log

class AppData {
    
    static let store = AppData()

    func getAvatar(id: UInt64) -> Avatar? {
        return avatars[id]
    }
    
    func addAvatar(id: UInt64, avatar: Avatar) {
        avatars[id] = avatar
        saveAvatars()
    }
    
    func getUser() -> User? {
        return user
    }
    
    func setUser(user: User) {
        self.user = user
        saveUser()
    }
    
    func showSummary() -> Bool {
        guard let preferences = preferences else {
            return false
        }
        return preferences.showSummary
    }
    
    func setShowSummary(showSummary: Bool) {
        preferences = Preferences(showSummary: showSummary, sortByVowels: sortByVowels())
        savePreferences()
    }
    
    func sortByVowels() -> Bool {
        guard let preferences = preferences else {
            return false
        }
        return preferences.sortByVowels
    }
    
    func setSortByVowels(sortByVowels: Bool) {
        preferences = Preferences(showSummary: showSummary(), sortByVowels: sortByVowels)
        savePreferences()
    }
    
    private var preferences: Preferences?
    private var user: User?
    private var avatars: [UInt64:Avatar]
    
    private func savePreferences() {
        NSKeyedArchiver.archiveRootObject(preferences!, toFile: Preferences.ArchiveURL.path)
    }
    
    private func saveUser() {
        NSKeyedArchiver.archiveRootObject(user!, toFile: User.ArchiveURL.path)
    }
    
    private func saveAvatars() {
        NSKeyedArchiver.archiveRootObject(avatars, toFile: Avatar.ArchiveURL.path)
    }
    
    private init() {
        preferences = NSKeyedUnarchiver.unarchiveObject(withFile: Preferences.ArchiveURL.path) as? Preferences
        user = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
        
        if let loadedAvatars = NSKeyedUnarchiver.unarchiveObject(withFile: Avatar.ArchiveURL.path) as? [UInt64:Avatar] {
            avatars = loadedAvatars
        } else {
            avatars = [UInt64:Avatar]()
        }
    }
    
}
