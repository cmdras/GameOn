//
//  GameInfoViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 15/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit

class GameInfoViewController: UIViewController {
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameSummary: UITextView!
    
    var selectedGame: Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedGame != nil) {
            loadGame(game: selectedGame!)
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
}
