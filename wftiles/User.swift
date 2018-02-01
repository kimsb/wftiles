//
//  User.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import os.log

class User: NSObject, NSCoding {
    let username: String
    let email: String
    let password: String
    let id: UInt64
    let avatarRoot: String
    let loginMethod: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    struct PropertyKey {
        static let username = "username"
        static let email = "email"
        static let password = "password"
        static let id = "id"
        static let avatarRoot = "avatarRoot"
        static let loginMethod = "loginMethod"
    }
    
    init(username: String, email: String, password: String, id: UInt64, avatarRoot: String, loginMethod: String) {
        self.username = username
        self.email = email
        self.password = password
        self.id = id
        self.avatarRoot = avatarRoot
        self.loginMethod = loginMethod
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(avatarRoot, forKey: PropertyKey.avatarRoot)
        aCoder.encode(loginMethod, forKey: PropertyKey.loginMethod)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let username = aDecoder.decodeObject(forKey: PropertyKey.username) as? String else {
            os_log("Unable to decode 'username' for User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String else {
            os_log("Unable to decode 'email' for User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String else {
            os_log("Unable to decode 'password' for User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? UInt64 else {
            os_log("Unable to decode 'id' for User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let avatarRoot = aDecoder.decodeObject(forKey: PropertyKey.avatarRoot) as? String else {
            os_log("Unable to decode 'avatarRoot' for User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let loginMethod = aDecoder.decodeObject(forKey: PropertyKey.loginMethod) as? String else {
            os_log("Unable to decode 'loginMethod' for User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(username: username, email: email, password: password, id: id, avatarRoot: avatarRoot, loginMethod:loginMethod)
    }
}
