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
    
    @IBOutlet weak var gamePlayersTable: UITableView!
    
    var username: String?
    var currentUser = FIRAuth.auth()!.currentUser!.uid
    var selectedGame: Game?
    var users = NSDictionary()
    var ref: FIRDatabaseReference?
    var gamesRef: FIRDatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Players of \(selectedGame!.title!)"
        ref = FIRDatabase.database().reference(withPath: "users")
        gamesRef = FIRDatabase.database().reference(withPath: "Games")
        self.getUsername(ref: ref!, currentUser: currentUser)
        getPlayersForGame(gamesRef: gamesRef!)
        gamePlayersTable.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamePlayersTable.dequeueReusableCell(withIdentifier: "playerNameCell", for: indexPath)
            as! GamePlayerCell
        cell.playerUsername.text = users.allKeys[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gamePlayersTable.deselectRow(at: indexPath, animated: true)
        if (users.allKeys[indexPath.row] as? String != self.username) {
            let playerKey = self.users.allKeys[indexPath.row] as! String
            let playerValue = self.users[playerKey] as! String
            
            let addPlayerAlert = UIAlertController(title: "Follow Player", message: "Do you want to follow \(users.allKeys[indexPath.row] as! String)", preferredStyle: UIAlertControllerStyle.alert)
            addPlayerAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.followPlayer(ref: self.ref!.child(self.currentUser), key: playerKey, value: playerValue)
            }))
            addPlayerAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            }))
            
            present(addPlayerAlert, animated: true, completion: nil)
        }
    }

    
    func getPlayersForGame(gamesRef: FIRDatabaseReference) {
        gamesRef.child(selectedGame!.title!.replacingOccurrences(of: ".", with: " ")).observeSingleEvent(of: .value, with: { (snapshot) in
            self.users = snapshot.value as! NSDictionary
            self.gamePlayersTable.reloadData()
        })
    }
    
    func getUsername(ref: FIRDatabaseReference, currentUser: String) {
        ref.child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String
        })
    }
    
    func followPlayer(ref: FIRDatabaseReference, key: String, value: String) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("Following Players") {
                let followedPlayers = snapshot.childSnapshot(forPath: "Following Players")
                let dict = followedPlayers.value as! NSDictionary
                let newDict = dict as! NSMutableDictionary
                newDict[key] = value
                ref.child("Following Players").setValue(newDict)
            } else {
                ref.child("Following Players").setValue([key: value])
            }
        })
    }

}
