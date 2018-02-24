//
//  Constants.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 29/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Constants {
    
    static let tiles = Constants()
    
    let counts, points: [[String:Int]]
    private let letters: [[String]]
    let locales = ["en", "nb", "nl", "da", "sv", "en", "es", "fr", "sv", "de", "nb", "fi", "pt"]
    
    func letters(ruleset: Int) -> [String] {
        if AppData.store.sortByVowels() {
            return letters[ruleset]
        }
        return letters[ruleset].sorted {
            $0.compare($1, locale: Locale(identifier: locales[ruleset])) == .orderedAscending
        }
    }
    
    //english
    private let englishLetters = ["", "A", "E", "I", "O", "U", "Y", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
    private let englishCounts = [2, 10, 12, 9, 7, 4, 2, 2, 2, 5, 2, 3, 3, 1, 1, 4, 2, 6, 2, 1, 6, 5, 7, 2, 2, 1, 1]
    private let englishPoints = [0, 1, 1, 1, 1, 2, 4, 4, 4, 2, 4, 3, 4, 10, 5, 1, 3, 1, 4, 10, 1, 1, 1, 4, 4, 8, 10]
    
    //norwegian
    private let norwegianLetters = ["", "A", "E", "I", "O", "U", "Y", "Æ", "Ø", "Å", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V", "W"]
    private let norwegianCounts = [2, 7, 9, 6, 4, 3, 1, 1, 2, 2, 3, 1, 5, 4, 4, 3, 2, 4, 5, 3, 6, 2, 7, 7, 7, 3, 1]
    private let norwegianPoints = [0, 1, 1, 2, 3, 4, 8, 8, 4, 4, 4, 10, 1, 2, 4, 3, 4, 3, 2, 2, 1, 4, 1, 1, 1, 5, 10]
    
    //dutch
    private let dutchLetters = ["", "A", "E", "I", "O", "U", "Y", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
    private let dutchCounts = [2, 7, 18, 4, 6, 3, 1, 2, 2, 5, 2, 3, 2, 2, 3, 3, 3, 11, 2, 1, 5, 5, 5, 2, 2, 1, 2]
    private let dutchPoints = [0, 1, 1, 2, 1, 2, 8, 4, 5, 2, 4, 3, 4, 4, 3, 3, 3, 1, 4, 10, 2, 2, 2, 4, 5, 8, 5]
    
    //danish
    private let danishLetters = ["", "A", "E", "I", "O", "U", "Æ", "Ø", "Å", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V", "X", "Y", "Z"]
    private let danishCounts = [2, 7, 9, 4, 5, 3, 2, 2, 2, 4, 2, 5, 3, 3, 2, 2, 4, 5, 3, 7, 2, 7, 6, 6, 3, 1, 2, 1]
    private let danishPoints = [0, 1, 1, 3, 2, 3, 4, 4, 4, 3, 8, 2, 3, 3, 4, 4, 3, 2, 4, 1, 4, 1, 2, 2, 4, 8, 4, 9]
    
    //swedish
    private let swedishLetters = ["", "A", "E", "I", "O", "U", "Y", "Å", "Ä", "Ö", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V", "X", "Z"]
    private let swedishCounts = [2, 9, 8, 5, 6, 3, 1, 2, 2, 2, 2, 1, 5, 2, 3, 2, 1, 3, 5, 3, 6, 2, 8, 8, 9, 2, 1, 1]
    private let swedishPoints = [0, 1, 1, 1, 2, 4, 7, 4, 4, 4, 3, 8, 1, 3, 2, 3, 7, 3, 2, 3, 1, 4, 1, 1, 1, 3, 8, 8]
    
    //spanish
    private let spanishLetters = ["", "A", "E", "I", "O", "U", "B", "C", "CH", "D", "F", "G", "H", "J", "L", "LL", "M", "N", "Ñ", "P", "Q", "R", "RR", "S", "T", "V", "X", "Y", "Z"]
    private let spanishCounts = [2, 13, 13, 6, 9, 5, 2, 4, 1, 5, 1, 2, 2, 1, 4, 1, 2, 6, 1, 2, 1, 5, 1, 7, 4, 1, 1, 1, 1]
    private let spanishPoints = [0, 1 , 1, 1, 1, 1, 3, 3, 5, 2, 4, 3, 4, 8, 1, 8, 3, 1, 8, 3, 5, 1, 8, 1, 2, 4, 8, 5, 10]
    
    //french
    private let frenchLetters = ["", "A", "E", "I", "O", "U", "Y", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]
    private let frenchCounts = [2, 10, 14, 9, 6, 6, 1, 2, 2, 3, 2, 3, 2, 1, 1, 5, 3, 6, 2, 1, 6, 6, 6, 2, 1, 1, 1]
    private let frenchPoints = [0, 1, 1, 1, 1, 1, 10, 3, 3, 2, 4, 2, 4, 8, 10, 2, 2, 1, 3, 8, 1, 1, 1, 5, 10, 10, 10]
    
    //german
    private let germanLetters = ["", "A", "Ä", "E", "I", "O", "Ö", "U", "Ü", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"]
    private let germanCounts = [2, 5, 1, 14, 6, 3, 1, 6, 1, 2, 2, 5, 2, 3, 4, 1, 2, 3, 4, 9, 1, 1, 6, 7, 6, 1, 1, 1, 1, 1]
    private let germanPoints = [0, 1, 6, 1, 1, 2, 8, 1, 6, 3, 4, 1, 4, 2, 2, 6, 4, 2, 3, 1, 5, 10, 1, 1, 1, 6, 3, 8, 10, 3]
    
    //finnish
    private let finnishLetters = ["", "A", "E", "I", "O", "U", "Y", "Ä", "Ö", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V"]
    private let finnishCounts = [2, 11, 9, 10, 5, 4, 2, 5, 1, 1, 1, 1, 1, 1, 2, 2, 6, 6, 3, 9, 2, 2, 7, 9, 2]
    private let finnishPoints = [0, 1, 1, 1, 2, 3, 4, 2, 7, 8, 10, 6, 8, 8, 4, 4, 3, 2, 3, 1, 4, 4, 1, 1, 4]
    
    //portugese
    private let portugeseLetters = ["", "A", "E", "I", "O", "U", "B", "C", "Ç", "D", "F", "G", "H", "J", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "X", "Z"]
    private let portugeseCounts = [2, 12, 10, 9, 9, 6, 3, 3, 2, 4, 2, 2, 2, 2, 4, 5, 3, 3, 1, 5, 7, 4, 2, 1, 1]
    private let portugesePoints = [0, 1, 1, 1, 1, 2, 4, 2, 3, 2, 5, 4, 4, 6, 2, 1, 3, 2, 8, 1, 2, 2, 4, 10, 10]
    
    private init() {
        counts = [Dictionary(uniqueKeysWithValues: zip(englishLetters, englishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(norwegianLetters, norwegianCounts)),
                        Dictionary(uniqueKeysWithValues: zip(dutchLetters, dutchCounts)),
                        Dictionary(uniqueKeysWithValues: zip(danishLetters, danishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(swedishLetters, swedishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(englishLetters, englishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(spanishLetters, spanishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(frenchLetters, frenchCounts)),
                        Dictionary(uniqueKeysWithValues: zip(swedishLetters, swedishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(germanLetters, germanCounts)),
                        Dictionary(uniqueKeysWithValues: zip(norwegianLetters, norwegianCounts)),
                        Dictionary(uniqueKeysWithValues: zip(finnishLetters, finnishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(portugeseLetters, portugeseCounts))]
        
        points = [Dictionary(uniqueKeysWithValues: zip(englishLetters, englishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(norwegianLetters, norwegianPoints)),
                        Dictionary(uniqueKeysWithValues: zip(dutchLetters, dutchPoints)),
                        Dictionary(uniqueKeysWithValues: zip(danishLetters, danishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(swedishLetters, swedishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(englishLetters, englishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(spanishLetters, spanishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(frenchLetters, frenchPoints)),
                        Dictionary(uniqueKeysWithValues: zip(swedishLetters, swedishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(germanLetters, germanPoints)),
                        Dictionary(uniqueKeysWithValues: zip(norwegianLetters, norwegianPoints)),
                        Dictionary(uniqueKeysWithValues: zip(finnishLetters, finnishPoints)),
                        Dictionary(uniqueKeysWithValues: zip(portugeseLetters, portugesePoints))]
        
        letters = [englishLetters, norwegianLetters, dutchLetters, danishLetters, swedishLetters, englishLetters,
            spanishLetters, frenchLetters, swedishLetters, germanLetters, norwegianLetters, finnishLetters, portugeseLetters]
    }
    
}
