//
//  GameInfoViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 15/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  This View displays information about a specific game. It also allows the user to add the game to the user's personal list. Furthermore, the user can see which players are currently playing the game

import UIKit
import Firebase

class GameInfoViewController: UIViewController {
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    var selectedGame: Game?
    
    // MARK: - Outlets
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameSummary: UITextView!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        if (selectedGame != nil) {
            loadGame(game: selectedGame!)
        }
        self.title = "Game Info"
    }
    
    // MARK: - Helper Functions
    func loadGame(game: Game) {
        gameTitleLabel.text = game.title
        gameSummary.text = game.summary
        if (game.coverUrl != "") {
            let url = URL(string: game.coverUrl!)
            gameImage.af_setImage(withURL: url!)
        } else {
            gameImage.image = #imageLiteral(resourceName: "stock")
        }
    }
    
    // MARK: - IBAction Functions
    @IBAction func playersButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "playersOfGameSegue", sender: nil)
    }
    
    @IBAction func watchGamesButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "watchVideos", sender: nil)
    }
    
    @IBAction func addGameTouched(_ sender: Any) {
        self.selectedGame?.saveToFirebase(myFirebase: ref)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playersVC = segue.destination as? GamePlayersViewController {
            playersVC.selectedGame = self.selectedGame
        } else if let watchVideosVC = segue.destination as? GameVideosVC {
            watchVideosVC.game = selectedGame
        }
    }
}
