//
//  HttpCommunicator.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 23/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import Foundation

class HttpCommunicator {
    
    struct Status: Codable {
        let status: String
    }
    
    func getGames() -> String {
        
        var returnString = ""
        
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
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(responseString)")
                returnString = responseString!
            }
        })
        
        dataTask.resume()
        return returnString
    }
    
    func connect() -> Void {
        
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
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                }
            })
            
            
            dataTask.resume()
        } catch {
            print("Noe galt skjedde...")
        }
    }
}
