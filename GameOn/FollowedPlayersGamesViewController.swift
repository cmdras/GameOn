//
//  FollowedPlayersGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 19/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  This View shows which games a user is playing. By tapping a game, the user can then get info from that game, and even add the game the the user's personal list.

import UIKit
import Firebase

class FollowedPlayersGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    var games = [Game?]()
    var username: String?
    var userID: String?
    var selectedGame: Game?
    
    // MARK: - Outlets
    @IBOutlet weak var followedPlayersTable: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(withPath: Constants.USERS)
        self.title = "Games played by \(username!)"
        retrieveListOfGames(ref: ref)
    }
    
    // MARK: - Helper Functions
    /// Recreate a Game object from data retrieved from Firebase
    func recreateGame(dict: [String: String]) -> Game {
        let game = Game()
        game.title = dict[Constants.TITLE]
        game.releaseDate = dict[Constants.RELEASE_DATE]
        game.coverUrl = dict[Constants.COVER_URL]
        game.summary = dict[Constants.SUMMARY]
        return game
    }
    
    /// Retrieve the list of Games stored in Firebase
    func retrieveListOfGames(ref: FIRDatabaseReference) {
        ref.child(userID!).child(Constants.GAMES).observe(.value, with: { snapshot in
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

