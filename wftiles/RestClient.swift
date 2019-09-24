//
//  RestClient.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 24/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation
import UIKit

class RestClient {
    
    static var client = RestClient()
    
    private init() {
    }
    
    struct LoginResponse: Decodable {
        let status: String
        let content: LoginContent
    }
    
    struct LoginContent: Decodable {
        let username: String?
        let email: String?
        let id: UInt64?
        let avatar_root: String?
        let type: String?
        let fb_first_name: String?
        let fb_middle_name: String?
        let fb_last_name: String?
        let avatar_updated: Double?
    }
    
    struct GamesResponse: Decodable {
        let status: String
        let content: GamesContent
    }
    
    struct GamesContent: Decodable {
        let games: [GameDecoder]?
        let type: String?
    }
    
    struct GameResponse: Decodable {
        let status: String
        let content: GameContent
    }
    
    struct GameContent: Decodable {
        let game: GameDecoder?
        let type: String?
    }
    
    struct GameDecoder: Decodable {
        let tiles: [[TileEnum]]?
        let is_running: Bool
        let id: UInt64
        let last_move: Move?
        let players: [Player]
        let ruleset: Int
        let current_player: Int
        let updated: UInt64
    }
    
    enum TileEnum: Decodable {
        case character(String)
        case wildcard(Bool)
        case ignoredPlacingInt(Int)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let value = try? container.decode(String.self) {
                self = .character(value)
            } else if let value = try? container.decode(Int.self) {
                self = .ignoredPlacingInt(value)
            } else if let value = try? container.decode(Bool.self) {
                self = .wildcard(value)
            } else {
                print("Decoding of TileEnum fails")
                let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown type")
                throw DecodingError.dataCorrupted(context)
            }
        }
    }
    
    func enumToLetter(values: [TileEnum]) -> String {
        if case .wildcard(let value) = values[3] {
            if value {
                return ""
            } else if case .character(let value) = values[2] {
                return value
            }
        }
        return "?"
    }
    
    func usedLettersToRemaining(ruleset: Int, usedLetters: [String]?, rack: [String]?) -> [String:Int] {
        if usedLetters == nil || Texts.shared.unsupportedLanguage(ruleset: ruleset) {
            return [String:Int]()
        }
        var letterCount = Constants.tiles.counts[ruleset]
        //find remaining letters
        for letter in usedLetters! {
            letterCount[letter]! -= 1
        }
        if rack != nil {
            for letter in rack! {
                letterCount[letter]! -= 1
            }
        }
        return letterCount
    }
    
    func gameDecoderToGame(gameDecoder: GameDecoder) -> Game {
        let opponent, loggedInPlayer: Player
        
        let playersTurn = gameDecoder.players[gameDecoder.current_player].id == AppData.shared.getUser()!.id
 
        if gameDecoder.players[0].id == AppData.shared.getUser()!.id {
            loggedInPlayer = gameDecoder.players[0]
            opponent = gameDecoder.players[1]
        } else {
            loggedInPlayer = gameDecoder.players[1]
            opponent = gameDecoder.players[0]
        }
        var usedLetters: [String]? = nil
        if let tiles = gameDecoder.tiles {
            usedLetters = tiles.map(self.enumToLetter)
        }
        let letterCount = usedLettersToRemaining(ruleset: gameDecoder.ruleset, usedLetters: usedLetters, rack: loggedInPlayer.rack)
        
        //sort rack alphabetically
        //skal dette også følge vokal/konsonant?
        if !Texts.shared.unsupportedLanguage(ruleset: gameDecoder.ruleset) {
        let locale = Locale(identifier: Constants.tiles.locales[gameDecoder.ruleset])
            
        loggedInPlayer.rack = loggedInPlayer.rack!.sorted {
            $0.compare($1, locale: locale) == .orderedAscending
        }
        }
        
        return Game(id: gameDecoder.id, letterCount: letterCount, isRunning: gameDecoder.is_running, opponent: opponent, player: loggedInPlayer, lastMove: gameDecoder.last_move, ruleset: gameDecoder.ruleset, playersTurn: playersTurn, updated: gameDecoder.updated)
    }
        
    func getGame(id: UInt64, completionHandler: @escaping (Game?, String?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "http://api.wordfeud.com/wf/game/\(id)/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("error not nil")
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                    completionHandler(nil, Texts.shared.getText(key: "connectionError"))
                    return
                }
                completionHandler(nil, "")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, "")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gameResponse = try decoder.decode(GameResponse.self, from: responseData)
                
                guard let game = gameResponse.content.game else {
                    if gameResponse.status == "error" && gameResponse.content.type != nil && gameResponse.content.type == "login_required" {
                        print("have to log in (game)")
                        completionHandler(nil, gameResponse.content.type)
                        return
                    }
                    completionHandler(nil, "")
                    return
                }
                
                completionHandler(self.gameDecoderToGame(gameDecoder: game), nil)
                
            } catch {
                print("error trying to convert data to JSON")
                completionHandler(nil, "")
            }
            
        })
        dataTask.resume()
    }
    
    func getGames(completionHandler: @escaping ([Game]?, String?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://api.wordfeud.com/wf/user/games/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else {
                print("error not nil")
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                    completionHandler(nil, Texts.shared.getText(key: "connectionError"))
                    return
                }
                completionHandler(nil, "")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, "")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gamesResponse = try decoder.decode(GamesResponse.self, from: responseData)
                
                guard let games = gamesResponse.content.games else {
                    if gamesResponse.status == "error" && gamesResponse.content.type != nil && gamesResponse.content.type == "login_required" {
                        print("have to log in")
                        completionHandler(nil, gamesResponse.content.type)
                        return
                    }
                    completionHandler(nil, "")
                    return
                }
                
                completionHandler(games.map(self.gameDecoderToGame), nil)
                
            } catch {
                print("error trying to convert data to JSON")
                completionHandler(nil, "")
            }
            
        })
        
        dataTask.resume()
    }
    
    //send inn enum med id/email
    func login(loginMethod: String, loginValue: String, password: String, completionHandler: @escaping (User?, String?) -> Void)  {
        
        let parameters = [
            "password": (password+"JarJarBinks9").sha1!,
            "\(loginMethod)": loginValue
            ] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: "http://api.wordfeud.com/wf/user/login/" + ("email" == loginMethod ? "email/" : ""))! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)

            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                guard error == nil else {
                    print("error not nil")
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                        completionHandler(nil, Texts.shared.getText(key: "connectionError"))
                        return
                    }
                    completionHandler(nil, "")
                    return
                }
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    completionHandler(nil, "")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let loginResponse = try decoder.decode(LoginResponse.self, from: responseData)
                    if loginResponse.status == "error" {
                        print("login failed")
                        switch loginResponse.content.type! {
                        case "unknown_email":
                            completionHandler(nil, Texts.shared.getText(key: "unknownEmail"))
                        case "unknown_username":
                            completionHandler(nil, Texts.shared.getText(key: "unknownUsername"))
                        default:
                            completionHandler(nil, Texts.shared.getText(key: "wrongPassword"))
                        }
                        return
                    }
                    
                    //start avatarhenting
                    self.getAvatar(playerId: loginResponse.content.id!, avatarRoot: loginResponse.content.avatar_root, completionHandler: { (avatar_data, error) in
                        if let error = error {
                            // got an error in getting the data, need to handle it
                            print("error calling GET for avatar")
                            print(error)
                            completionHandler(nil, "")
                            return
                        }
                        guard let avatar_data = avatar_data else {
                            print("error getting avatar: result is nil")
                            completionHandler(nil, "")
                            return
                        }
                        // success :)
                        let avatar = Avatar(image: UIImage(data: avatar_data) ?? UIImage(named: "black_circle")!, updated: UInt64(loginResponse.content.avatar_updated ?? Date().timeIntervalSince1970), lastShown: Date())
                        let user = User(username: loginResponse.content.username!, email: loginResponse.content.email!, password: password,
                                        id: loginResponse.content.id!, avatarRoot: loginResponse.content.avatar_root!, loginMethod: loginMethod, fb_first_name: loginResponse.content.fb_first_name, fb_middle_name: loginResponse.content.fb_middle_name, fb_last_name: loginResponse.content.fb_last_name, avatar: avatar)
                        AppData.shared.addUser(user: user)
                        completionHandler(user, nil)
                    })
                    //slutt avatarhenting
                } catch {
                    print("error trying to convert data to JSON")
                    completionHandler(nil, "")
                }
            })
                        
            dataTask.resume()
        } catch {
            completionHandler(nil, "")
        }
    }
    
    func getAvatar(playerId: UInt64, avatarRoot: String?, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        if avatarRoot == nil {
            print("Error: avatarRoot is nil")
            completionHandler(nil, nil)
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(avatarRoot!)/80/\(playerId)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 5.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
                        
            completionHandler(responseData, nil)
            
        })
        dataTask.resume()
    }
    
    let headers = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Cache-Control": "no-cache",
        ]
}
