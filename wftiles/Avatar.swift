//
//  Avatar.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 30/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class Avatar: NSObject, NSCoding {
    let image: UIImage
    let updated: UInt64
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("avatars")
    
    struct PropertyKey {
        static let image = "image"
        static let updated = "updated"
    }
    
    init(image: UIImage, updated: UInt64) {
        self.image = image
        self.updated = updated
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(updated, forKey: PropertyKey.updated)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as! UIImage
        let updated = aDecoder.decodeObject(forKey: PropertyKey.updated) as! UInt64
        
        self.init(image: image, updated: updated)
    }
}
