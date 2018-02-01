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
    
    private var user: User?
    private var avatars: [UInt64:Avatar] // = [UInt64:Avatar]()
    
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
