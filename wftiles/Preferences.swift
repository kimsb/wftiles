//
//  Preferences.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 16/02/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Preferences: NSObject, NSCoding {
    let showSummary: Bool
    let sortByVowels: Bool
    let languageIndex: Int?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("preferences")
    
    struct PropertyKey {
        static let showSummary = "showSummary"
        static let sortByVowels = "sortByVowels"
        static let languageIndex = "languageIndex"
    }
    
    init(showSummary: Bool, sortByVowels: Bool, languageIndex: Int?) {
        self.showSummary = showSummary
        self.sortByVowels = sortByVowels
        self.languageIndex = languageIndex
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(showSummary, forKey: PropertyKey.showSummary)
        aCoder.encode(sortByVowels, forKey: PropertyKey.sortByVowels)
        aCoder.encode(languageIndex, forKey: PropertyKey.languageIndex)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let showSummary = Bool(aDecoder.decodeBool(forKey: PropertyKey.showSummary))
        let sortByVowels = Bool(aDecoder.decodeBool(forKey: PropertyKey.sortByVowels))
        let languageIndex = aDecoder.decodeObject(forKey: PropertyKey.languageIndex) as? Int
        
        self.init(showSummary: showSummary, sortByVowels: sortByVowels, languageIndex: languageIndex)
    }
}
