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
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(preferences!, toFile: Preferences.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Preferences successfully saved.", log: OSLog.default, type: .debug)
            
            print("preferences showSummary: \(preferences!.showSummary), sortByVowels: \(preferences!.sortByVowels)")
            
        } else {
            os_log("Failed to save preferences...", log: OSLog.default, type: .error)
        }
    }
    
    private func saveUser() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user!, toFile: User.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("User successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save user...", log: OSLog.default, type: .error)
        }
    }
    
    private func saveAvatars() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(avatars, toFile: Avatar.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Avatars successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save avatars...", log: OSLog.default, type: .error)
        }
    }
    
    private init() {
        let loadedPreferences = NSKeyedUnarchiver.unarchiveObject(withFile: Preferences.ArchiveURL.path) as? Preferences
        if loadedPreferences == nil {
            os_log("No preferences loaded", log: OSLog.default, type: .debug)
        } else {
            os_log("Preferences successfully loaded.", log: OSLog.default, type: .debug)
        }
        preferences = loadedPreferences
        
        let loadedUser = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
        if loadedUser == nil {
            os_log("No user loaded", log: OSLog.default, type: .debug)
        } else {
            os_log("User successfully loaded.", log: OSLog.default, type: .debug)
        }
        user = loadedUser
        
        if let loadedAvatars = NSKeyedUnarchiver.unarchiveObject(withFile: Avatar.ArchiveURL.path) as? [UInt64:Avatar] {
            os_log("Avatars successfully loaded.", log: OSLog.default, type: .debug)
            avatars = loadedAvatars
        } else {
            os_log("No avatars loaded", log: OSLog.default, type: .debug)
            avatars = [UInt64:Avatar]()
        }
    }
    
}
