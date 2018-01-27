//
//  GameViewController.swift
//  wftiles
//
//  Created by Kim Stephen Bovim on 27/01/2018.
//  Copyright © 2018 Kim Stephen Bovim. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: Properties
    var game: Game!
    @IBOutlet weak var opponentImageView: UIImageView!
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    @IBOutlet weak var myLettersLabel: UILabel!
    @IBOutlet weak var remainingLettersLabel: UILabel!
    
    func loadGame() {
        guard let game = self.game else {
            print("No game to show")
            return
        }
        
        let gameWithTiles = RestClient().getGame(id: game.id, completionHandler: { (game, error) in
            if let error = error {
                // got an error in getting the data, need to handle it
                print("error calling POST for Game")
                print(error)
                return
            }
            guard let game = game else {
                print("error getting game: result is nil")
                return
            }
            // success :)
            debugPrint(game)
            self.game = game
            DispatchQueue.main.async(execute: {
                //perform all UI stuff here
                self.remainingLettersLabel.text = "\(game.usedLetters!)"
            })
        })
        
        opponentImageView.image = UIImage(data: game.opponent.avatar!)
        opponentLabel.text = game.opponent.username
        scoreLabel.text = "(\(game.player.score) - \(game.opponent.score))"
        lastMoveLabel.text = game.lastMove.move_type
        myLettersLabel.text = "\(game.player.rack!)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load game
        loadGame()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
