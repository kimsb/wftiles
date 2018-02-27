//
//  RestClient.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 24/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class RestClient {
    
    static var client = RestClient()
    static var count = 0
    
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
        let game: GameDecoder
    }
    
    struct GameDecoder: Decodable {
        let tiles: [[TileEnum]]?
        let is_running: Bool
        let bag_count: Int?
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
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let value = try? container.decode(String.self) {
                self = .character(value)
            } else if let value = try? container.decode(Int.self) {
                self = .wildcard(value > 0)
            } else {
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
    
    func gameDecoderToGame(gameDecoder: GameDecoder) -> Game {
        let opponent, loggedInPlayer: Player
        var letters: [String]? = nil
        
        let playersTurn = gameDecoder.players[gameDecoder.current_player].id == AppData.store.getUser()!.id
        
        if gameDecoder.players[0].id == AppData.store.getUser()!.id {
            loggedInPlayer = gameDecoder.players[0]
            opponent = gameDecoder.players[1]
        } else {
            loggedInPlayer = gameDecoder.players[1]
            opponent = gameDecoder.players[0]
        }
        
        
        if let tiles = gameDecoder.tiles {
            letters = tiles.map(self.enumToLetter)
        }
        
        return Game(id: gameDecoder.id, usedLetters: letters, isRunning: gameDecoder.is_running, bagCount: gameDecoder.bag_count, opponent: opponent, player: loggedInPlayer, lastMove: gameDecoder.last_move, ruleset: gameDecoder.ruleset, playersTurn: playersTurn, updated: gameDecoder.updated)
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
                let gameDecoder = gameResponse.content.game
                let game = self.gameDecoderToGame(gameDecoder: gameDecoder)
                
                completionHandler(game, nil)
                
            } catch {
                print("error trying to convert data to JSON")
                completionHandler(nil, "")
            }
            
        })
        dataTask.resume()
    }
    
    func getGames(completionHandler: @escaping ([Game]?, String?) -> Void) {
        
        //TEST
        if RestClient.count == 0 {
            RestClient.count += 1
            let cookieStore = HTTPCookieStorage.shared
            for cookie in cookieStore.cookies ?? [] {
                cookieStore.deleteCookie(cookie)
            }
        }
        
        
        
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
                    let user = User(username: loginResponse.content.username!, email: loginResponse.content.email!, password: password,
                                    id: loginResponse.content.id!, avatarRoot: loginResponse.content.avatar_root!, loginMethod: loginMethod)
                    AppData.store.setUser(user: user)
                    completionHandler(user, nil)
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
    
    func getAvatar(opponentId: UInt64, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(AppData.store.getUser()!.avatarRoot)/80/\(opponentId)")! as URL,
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
