//
//  UsersGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Delete functionality adapted from: http://stackoverflow.com/questions/39631998/how-to-delete-from-firebase-database
//
//  This view shows the games which are stored in the users personal list. By tapping on a game, the user is presented info about the game.

import UIKit
import Firebase

class UsersGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    let username = FIRAuth.auth()!.currentUser!.displayName
    var usersGames = Array<Game>()
    var ref: FIRDatabaseReference!
    var gamesRef: FIRDatabaseReference!
    var selectedGame: Game?
    
    // MARK: - Outlets
    @IBOutlet weak var gamesTable: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        ref = FIRDatabase.database().reference(withPath: Constants.USERS)
        gamesRef = FIRDatabase.database().reference(withPath: Constants.GAMES)
        self.retrieveListOfGames(ref: ref)
        self.title = "My Games"
    }
    
    // MARK: - Helper Functions
    func retrieveListOfGames(ref: FIRDatabaseReference) {
        ref.child(userID).child(Constants.GAMES).observe(.value, with: { snapshot in
            self.usersGames.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                self.usersGames.append(self.recreateGame(dict: child.value! as! [String : String]))
            }
            self.gamesTable.reloadData()
        })
    }

    /// Recreate a Game object from data retrieved from Firebase
    func recreateGame(dict: [String: String]) -> Game {
        let game = Game()
        game.title = dict[Constants.TITLE]
        game.releaseDate = dict[Constants.RELEASE_DATE]
        game.coverUrl = dict[Constants.COVER_URL]
        game.summary = dict[Constants.SUMMARY]
        return game
    }
    
    /// Delete a game from Firebase
    func deleteGame(childIWantToRemove: String) {
        ref.child(userID).child(Constants.GAMES).child(childIWantToRemove.replacingOccurrences(of: ".", with: " ")).removeValue { (error, ref) in
            if error != nil {
                let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        gamesRef.child(childIWantToRemove.replacingOccurrences(of: ".", with: " ")).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let newDict = value as? NSMutableDictionary
            newDict?[self.username!] = nil
            self.gamesRef.child(childIWantToRemove.replacingOccurrences(of: ".", with: " ")).setValue(newDict!)
            
        })
    }
    
    // MARK: Table View Handling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTable.dequeueReusableCell(withIdentifier: "gameInfoCell", for: indexPath)
            as! GameCell
        
        cell.gameTitle.text = usersGames[indexPath.row].title
        cell.gameRelease.text = usersGames[indexPath.row].releaseDate
        if (usersGames[indexPath.row].coverUrl! != "") {
            let url = URL(string: usersGames[indexPath.row].coverUrl!)
            cell.gameImage.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "stock"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        } else {
            cell.gameImage.image = #imageLiteral(resourceName: "stock")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGame = usersGames[indexPath.row]
        gamesTable.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "gameInfoSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.deleteGame(childIWantToRemove: usersGames[indexPath.row].title!)
            self.usersGames.remove(at: indexPath.row)
            gamesTable.reloadData()
            
        }
    }
    
    // IBAction Functions
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        try! FIRAuth.auth()!.signOut()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.animateToDestinationController(storyboardId: "LoginViewController")
        }
    }
    
    // Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoVC = segue.destination as? GameInfoViewController {
            infoVC.selectedGame = self.selectedGame
        }
    }
}
