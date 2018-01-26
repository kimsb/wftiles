//
//  LoginUser.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 25/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

struct LoginUser: Codable {
    let username: String
    let id: UInt64
    let avatar_root: String
}
