//
//  GamePlayersViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 18/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class GamePlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    let ref = FIRDatabase.database().reference(withPath: "users")
    let gamesRef = FIRDatabase.database().reference(withPath: "Games")
    let usernamesRef = FIRDatabase.database().reference(withPath: "usernames")
    let username = FIRAuth.auth()?.currentUser?.displayName
    var currentUser = FIRAuth.auth()!.currentUser!.uid
    var selectedGame: Game?
    var users = NSDictionary()
    
    // MARK: - Outlets
    @IBOutlet weak var gamePlayersTable: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Players of \(selectedGame!.title!)"
        getPlayersForGame(gamesRef: gamesRef)
        gamePlayersTable.reloadData()
        
    }
    
    // MARK: - Helper Functions
    func getPlayersForGame(gamesRef: FIRDatabaseReference) {
        gamesRef.child(selectedGame!.title!.replacingOccurrences(of: ".", with: " ")).observeSingleEvent(of: .value, with: { (snapshot) in
            let gamePlayers = snapshot.value as? NSDictionary
            if gamePlayers != nil {
                self.users = gamePlayers!
                self.gamePlayersTable.reloadData()
            } else {
                let alertController = UIAlertController(title: "No players :(", message: "No one seems to be playing \(self.selectedGame!.title!)", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
    }
    
    func followPlayer(ref: FIRDatabaseReference, key: String, value: String) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.usernamesRef.child(key).observeSingleEvent(of: .value, with: { (usernamesSnapshot) in
                var imageURL = ""
                if let userData = usernamesSnapshot.value as? NSDictionary {
                    imageURL = userData["ProfileImage"] as! String
                }
                if snapshot.hasChild("Following Players") {
                    let followedPlayers = snapshot.childSnapshot(forPath: "Following Players")
                    let dict = followedPlayers.value as! NSDictionary
                    let newDict = dict as! NSMutableDictionary
                    newDict[key] = ["ID": value, "image": imageURL]
                    ref.child("Following Players").setValue(newDict)
                } else {
                    ref.child("Following Players").setValue([key: ["ID": value, "image": imageURL]])
                }
            })
        })
    }
    
    // MARK: - Table View Handling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamePlayersTable.dequeueReusableCell(withIdentifier: "playerNameCell", for: indexPath)
            as! GamePlayerCell
        cell.playerUsername.text = users.allKeys[indexPath.row] as? String
        cell.playerImage.image = #imageLiteral(resourceName: "user_stock")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gamePlayersTable.deselectRow(at: indexPath, animated: true)
        if (users.allKeys[indexPath.row] as? String != self.username) {
            let playerKey = self.users.allKeys[indexPath.row] as! String
            let playerValue = self.users[playerKey] as! String
            let addPlayerAlert = UIAlertController(title: "Follow Player", message: "Do you want to follow \(users.allKeys[indexPath.row] as! String)", preferredStyle: UIAlertControllerStyle.alert)
            addPlayerAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.followPlayer(ref: self.ref.child(self.currentUser), key: playerKey, value: playerValue)
            }))
            addPlayerAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(addPlayerAlert, animated: true, completion: nil)
        }
    }
}
