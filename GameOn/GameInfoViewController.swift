//
//  GameInfoViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 15/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class GameInfoViewController: UIViewController {
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameSummary: UITextView!
    
    var ref: FIRDatabaseReference?
    var selectedGame: Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedGame != nil) {
            loadGame(game: selectedGame!)
            ref = FIRDatabase.database().reference()
        }

    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func addGameTouched(_ sender: Any) {
        self.selectedGame?.saveToFirebase(myFirebase: ref!)
    }
}
