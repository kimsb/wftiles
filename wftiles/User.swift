//
//  User.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    let username: String
    let email: String
    let password: String
    let id: UInt64
    let avatarRoot: String
    let loginMethod: String
    let fb_first_name: String?
    let fb_middle_name: String?
    let fb_last_name: String?
    
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
        static let fb_first_name = "fb_first_name"
        static let fb_middle_name = "fb_middle_name"
        static let fb_last_name = "fb_last_name"
    }
    
    init(username: String, email: String, password: String, id: UInt64, avatarRoot: String, loginMethod: String, fb_first_name: String?, fb_middle_name: String?, fb_last_name: String?) {
        self.username = username
        self.email = email
        self.password = password
        self.id = id
        self.avatarRoot = avatarRoot
        self.loginMethod = loginMethod
        self.fb_first_name = fb_first_name
        self.fb_middle_name = fb_middle_name
        self.fb_last_name = fb_last_name
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(email, forKey: PropertyKey.email)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(avatarRoot, forKey: PropertyKey.avatarRoot)
        aCoder.encode(loginMethod, forKey: PropertyKey.loginMethod)
        aCoder.encode(fb_first_name, forKey: PropertyKey.fb_first_name)
        aCoder.encode(fb_middle_name, forKey: PropertyKey.fb_middle_name)
        aCoder.encode(fb_last_name, forKey: PropertyKey.fb_last_name)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: PropertyKey.username) as! String
        let email = aDecoder.decodeObject(forKey: PropertyKey.email) as! String
        let password = aDecoder.decodeObject(forKey: PropertyKey.password) as! String
        let id = aDecoder.decodeObject(forKey: PropertyKey.id) as! UInt64
        let avatarRoot = aDecoder.decodeObject(forKey: PropertyKey.avatarRoot) as! String
        let loginMethod = aDecoder.decodeObject(forKey: PropertyKey.loginMethod) as! String
        let fb_first_name = aDecoder.decodeObject(forKey: PropertyKey.fb_first_name) as? String
        let fb_middle_name = aDecoder.decodeObject(forKey: PropertyKey.fb_middle_name) as? String
        let fb_last_name = aDecoder.decodeObject(forKey: PropertyKey.fb_last_name) as? String
        
        self.init(username: username, email: email, password: password, id: id, avatarRoot: avatarRoot, loginMethod:loginMethod, fb_first_name: fb_first_name, fb_middle_name: fb_middle_name, fb_last_name: fb_last_name)
    }
    
    func presentableFullUsername() -> String {
        if username.hasPrefix("_fb_") && !(fb_first_name ?? "").isEmpty {
            return fb_first_name! +
                (fb_middle_name == nil ? "" : " \(fb_middle_name!)") +
                (fb_last_name == nil ? "" : " \(fb_last_name!)")
        }
        return username
    }
}
