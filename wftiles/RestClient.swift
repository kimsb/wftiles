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
        let content: LoginContent
    }
    
    struct LoginContent: Codable {
        let username: String
        let id: UInt64
        let avatar_root: String
    }
    
    struct GamesResponse: Codable {
        let status: String
        let content: GamesContent
    }
    
    struct GamesContent: Codable {
        let games: [Game]
    }
    
    struct Game: Codable {
        let id: UInt64
        let is_running: Bool
    }
    
    func getGameIds() -> String {
        
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
                return
            }
            guard error == nil else {
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let gamesResponse = try decoder.decode(GamesResponse.self, from: responseData)
                print("games:")
                print(gamesResponse.status)
                print(gamesResponse.content.games.count)
                
                let gameIds = gamesResponse.content.games.map({ (game: Game) -> UInt64 in
                    game.id
                })
                for id in gameIds {
                    print("Id: \(id)")
                }
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
            
        })
        
        dataTask.resume()
        return "hei"
    }
    
    func login() -> Void {
        
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
                    return
                }
                guard error == nil else {
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let loginResponse = try decoder.decode(LoginResponse.self, from: responseData)
                    print("Login:")
                    print(loginResponse.status)
                    print(loginResponse.content.username)
                    print(loginResponse.content.id)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                }
            })
            
            
            dataTask.resume()
        } catch {
            print("Noe galt skjedde...")
        }
    }
}
