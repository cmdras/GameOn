//
//  FollowedPlayersGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 19/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class FollowedPlayersGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    let ref = FIRDatabase.database().reference(withPath: "users")
    var games = [Game?]()
    var username: String?
    var userID: String?
    var selectedGame: Game?
    
    // MARK: - Outlets
    @IBOutlet weak var followedPlayersTable: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games played by \(username!)"
        retrieveListOfGames(ref: ref)
    }
    
    // MARK: - Helper Functions
    func recreateGame(dict: [String: String]) -> Game {
        let game = Game()
        game.title = dict["title"]
        game.releaseDate = dict["releaseDate"]
        game.coverUrl = dict["coverUrl"]
        game.summary = dict["summary"]
        return game
    }
    
    func retrieveListOfGames(ref: FIRDatabaseReference) {
        ref.child(userID!).child("Games").observe(.value, with: { snapshot in
            self.games.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                self.games.append(self.recreateGame(dict: child.value! as! [String : String]))
            }
            self.followedPlayersTable.reloadData()
        })
    }
    
    // MARK: - Table View Handling
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = followedPlayersTable.dequeueReusableCell(withIdentifier: "followedGameCell", for: indexPath)
            as! FollowedPlayerGameCell
        cell.gameTitle.text = games[indexPath.row]!.title
        cell.gameRelease.text = games[indexPath.row]!.releaseDate
        if (games[indexPath.row]!.coverUrl! != "") {
            let url = URL(string: games[indexPath.row]!.coverUrl!)
            cell.gameImage.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "stock"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        } else {
            cell.gameImage.image = #imageLiteral(resourceName: "stock")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGame = games[indexPath.row]
        followedPlayersTable.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "followedGameSegue", sender: nil)
    }
    
    // MARK: - Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameInfoVC = segue.destination as? GameInfoViewController {
            gameInfoVC.selectedGame = selectedGame
        }
    }
    
    
}

