//
//  Constants.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 29/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class Constants {
    
    static let letters = Constants()
    
    let languages = ["English (US)", "Norwegian (bokmål)", "Dutch", "Danish", "Swedish", "English (Intl)", "Spanish", "French", "Swedish (strict)",
                     "German", "Norwegian (nynorsk)", "Finnish", "Portuguese"]
    
    let locales = ["en", "nb", "nl", "da", "sv", "en", "es", "fr", "sv", "de", "nn", "fi", "pt"]
    
    let counts, points: [[String:Int]]
    
    //english
    private let englishLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "-"]
    private let englishCounts = [10, 2, 2, 5, 12, 2, 3, 3, 9, 1, 1, 4, 2, 6, 7, 2, 1, 6, 5, 7, 4, 2, 2, 1, 2, 1, 2]
    private let englishPoints = [1, 4, 4, 2, 1, 4, 3, 4, 1, 10, 5, 1, 3, 1, 1, 4, 10, 1, 1, 1, 2, 4, 4, 8, 4, 10, 0]
    
    //norwegian
    private let norwegianLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W", "Y", "Æ", "Ø", "Å", "-"]
    private let norwgianCounts = [7, 3, 1, 5, 9, 4, 4, 3, 6, 2, 4, 5, 3, 6, 4, 2, 7, 7, 7, 3, 3, 1, 1, 1, 2, 2, 2]
    private let norwegianPoints = [1, 4, 10, 1, 1, 2, 4, 3, 2, 4, 3, 2, 2, 1, 3, 4, 1, 1, 1, 4, 5, 10, 8, 8, 4, 4, 0]
    
    //dutch
    private let dutchLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "-"]
    private let dutchCounts = [7, 2, 2, 5, 18, 2, 3, 2, 4, 2, 3, 3, 3, 11, 6, 2, 1, 5, 5, 5, 3, 2, 2, 1, 1, 2, 2]
    private let dutchPoints = [1, 4, 5, 2, 1, 4, 3, 4, 2, 4, 3, 3, 3, 1, 1, 4, 10, 2, 2, 2, 2, 4, 5, 8, 8, 5, 0]
    
    //danish
    private let danishLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "X", "Y", "Z", "Æ", "Ø", "Å", "-"]
    private let danishCounts = [7, 4, 2, 5, 9, 3, 3, 2, 4, 2, 4, 5, 3, 7, 5, 2, 7, 6, 6, 3, 3, 1, 2, 1, 2, 2, 2, 2]
    private let danishPoints = [1, 3, 8, 2, 1, 3, 3, 4, 3, 4, 3, 2, 4, 1, 2, 4, 1, 2, 2, 3, 4, 8, 4, 9, 4, 4, 4, 0]
    
    //swedish
    private let swedishLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "X", "Y", "Z", "Å", "Ä", "Ö", "-"]
    private let swedishCounts = [9, 2, 1, 5, 8, 2, 3, 2, 5, 1, 3, 5, 3, 6, 6, 2, 8, 8, 9, 3, 2, 1, 1, 1, 2, 2, 2, 2]
    private let swedishPoints = [1, 3, 8, 1, 1, 3, 2, 3, 1, 7, 3, 2, 3, 1, 2, 4, 1, 1, 1, 4, 3, 8, 7, 8, 4, 4, 4, 0]
    
    //spanish
    private let spanishLetters = ["A", "B", "C", "CH", "D", "E", "F", "G", "H", "I", "J", "L", "LL", "M", "N", "Ñ", "O", "P", "Q", "R", "RR", "S", "T", "U", "V", "X", "Y", "Z", "-"]
    private let spanishCounts = [13, 2, 4, 1, 5, 13, 1, 2, 2, 6, 1, 4, 1, 2, 6, 1, 9, 2, 1, 5, 1, 7, 4, 5, 1, 1, 1, 1, 2]
    private let spanishPoints = [1, 3, 3, 5, 2, 1, 4, 3, 4, 1, 8, 1, 8, 3, 1, 8, 1, 3, 5, 1, 8, 1, 2, 1, 4, 8, 5, 10, 0]
    
    //french
    private let frenchLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "-"]
    private let frenchCounts = [10, 2, 2, 3, 14, 2, 3, 2, 9, 1, 1, 5, 3, 6, 6, 2, 1, 6, 6, 6, 6, 2, 1, 1, 1, 1, 2]
    private let frenchPoints = [1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 10, 2, 2, 1, 1, 3, 8, 1, 1, 1, 1, 5, 10, 10, 10, 10, 0]
    
    //german
    private let germanLetters = ["A", "Ä", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "Ö", "P", "Q", "R", "S", "T", "U", "Ü", "V", "W", "X", "Y", "Z", "-"]
    private let germanCounts = [5, 1, 2, 2, 5, 14, 2, 3, 4, 6, 1, 2, 3, 4, 9, 3, 1, 1, 1, 6, 7, 6, 6, 1, 1, 1, 1, 1, 1, 2]
    private let germanPoints = [1, 6, 3, 4, 1, 1, 4, 2, 2, 1, 6, 4, 2, 3, 1, 2, 8, 5, 10, 1, 1, 1, 1, 6, 6, 3, 8, 10, 3, 0]
    
    //finnish
    private let finnishLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "Y", "Ä", "Ö", "-"]
    private let finnishCounts = [11, 1, 1, 1, 9, 1, 1, 2, 10, 2, 6, 6, 3, 9, 5, 2, 2, 7, 9, 4, 2, 2, 5, 1, 2]
    private let finnishPoints = [1, 8, 10, 6, 1, 8, 8, 4, 1, 4, 3, 2, 3, 1, 2, 4, 4, 1, 1, 3, 4, 4, 2, 7, 0]
    
    //portugese
    private let portugeseLetters = ["A", "B", "C", "Ç", "D", "E", "F", "G", "H", "I", "J", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Z", "-"]
    private let portugeseCounts = [12, 3, 3, 2, 4, 10, 2, 2, 2, 9, 2, 4, 5, 3, 9, 3, 1, 5, 7, 4, 6, 2, 1, 1, 2]
    private let portugesePoints = [1, 4, 2, 3, 2, 1, 5, 4, 4, 1, 6, 2, 1, 3, 1, 2, 8, 1, 2, 2, 2, 4, 10, 10, 0]
    
    private init() {
        counts = [Dictionary(uniqueKeysWithValues: zip(englishLetters, englishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(norwegianLetters, norwgianCounts)),
                        Dictionary(uniqueKeysWithValues: zip(dutchLetters, dutchCounts)),
                        Dictionary(uniqueKeysWithValues: zip(danishLetters, danishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(swedishLetters, swedishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(englishLetters, englishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(spanishLetters, spanishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(frenchLetters, frenchCounts)),
                        Dictionary(uniqueKeysWithValues: zip(swedishLetters, swedishCounts)),
                        Dictionary(uniqueKeysWithValues: zip(germanLetters, germanCounts)),
                        Dictionary(uniqueKeysWithValues: zip(norwegianLetters, norwgianCounts)),
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
    }
    
}
