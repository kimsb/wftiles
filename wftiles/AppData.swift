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
    
    private var avatars:[UInt64:Avatar] // = [UInt64:Avatar]()

    private func saveAvatars() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(avatars, toFile: Avatar.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Avatars successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save avatars...", log: OSLog.default, type: .error)
        }
    }
    
    private init() {
        if let loadedAvatars = NSKeyedUnarchiver.unarchiveObject(withFile: Avatar.ArchiveURL.path) as? [UInt64:Avatar] {
            avatars = loadedAvatars
            os_log("Avatars successfully loaded.", log: OSLog.default, type: .debug)
        } else {
            avatars = [UInt64:Avatar]()
            os_log("No avatars loaded", log: OSLog.default, type: .debug)
        }
    }
    
}
