//
//  RestClient.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 24/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class RestClient {
    
    struct LoginResponse: Codable {
        let status: String
        let content: LoginUser
    }
    
    struct GamesResponse: Decodable {
        let status: String
        let content: GamesContent
    }
    
    struct GamesContent: Decodable {
        let games: [GameDecoder]
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
                return "-"
            } else if case .character(let value) = values[2] {
                return value
            }
        }
        return "?"
    }
    
    func gameDecoderToGame(gameDecoder: GameDecoder) -> Game {
        let userId = 8443993
        let opponent, loggedInPlayer: Player
        var letters: [String]? = nil
        
        if gameDecoder.players[0].id == userId {
            loggedInPlayer = gameDecoder.players[0]
            opponent = gameDecoder.players[1]
        } else {
            loggedInPlayer = gameDecoder.players[1]
            opponent = gameDecoder.players[0]
        }
        
        if let tiles = gameDecoder.tiles {
            letters = tiles.map(self.enumToLetter)
        }
        
        return Game(id: gameDecoder.id, usedLetters: letters, isRunning: gameDecoder.is_running, bagCount: gameDecoder.bag_count, opponent: opponent, player: loggedInPlayer, lastMove: gameDecoder.last_move)
    }
    
    func getGame(id: UInt64, completionHandler: @escaping (Game?, Error?) -> Void) {
        
        print("Entering game-func...")
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Cache-Control": "no-cache",
            ]
        
        print("Id: \(id)")
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://api.wordfeud.com/wf/game/\(id)/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
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
            
            let decoder = JSONDecoder()
            do {
                let gameResponse = try decoder.decode(GameResponse.self, from: responseData)
                print("games:")
                print(gameResponse.status)
                
                let gameDecoder = gameResponse.content.game
                let game = self.gameDecoderToGame(gameDecoder: gameDecoder)
                
                completionHandler(game, nil)
                
            } catch {
                print("error trying to convert data to JSON")
                completionHandler(nil, error)
                print(error)
            }
            
        })
        dataTask.resume()
    }
    
    func getGames(completionHandler: @escaping ([Game]?, Error?) -> Void) {
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Cache-Control": "no-cache",
            ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://api.wordfeud.com/wf/user/games/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
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
            
            let decoder = JSONDecoder()
            do {
                let gamesResponse = try decoder.decode(GamesResponse.self, from: responseData)
                print("games:")
                print(gamesResponse.status)
                print(gamesResponse.content.games.count)
                
                completionHandler(gamesResponse.content.games.map(self.gameDecoderToGame), nil)
                
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
            
        })
        
        dataTask.resume()
    }
    
    func login(completionHandler: @escaping (LoginUser?, Error?) -> Void)  {
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Cache-Control": "no-cache",
            ]
        let parameters = [
            "password": "f5efa36b1fe6763fc936fd92569bb7e0ad1ae986",
            "email": "kbovim@hotmail.com"
            ] as [String : Any]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "http://api.wordfeud.com/wf/user/login/email/")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
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
                
                let decoder = JSONDecoder()
                do {
                    let loginResponse = try decoder.decode(LoginResponse.self, from: responseData)
                    print("Login:")
                    print(loginResponse.status)
                    print(loginResponse.content.username)
                    print(loginResponse.content.id)
                    completionHandler(loginResponse.content, nil)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(nil, error)
                }
            })
            
            
            dataTask.resume()
        } catch {
            print("Noe galt skjedde...")
            completionHandler(nil, error)
        }
    }
    
    func getAvatar(avatar_url: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        print("Entering getAvatar...")
        //må bare hente bilde hvis det ikke allerede er cachet, eller avatar_updated er ny
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Cache-Control": "no-cache",
            ]
        
        let request = NSMutableURLRequest(url: NSURL(string: avatar_url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
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
            
            print("har lastet ned image")
            
            completionHandler(responseData, nil)
            
        })
        dataTask.resume()
    }
}
