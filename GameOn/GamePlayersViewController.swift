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
        if (cell.playerUsername.text == self.username) {
            cell.addPlayerButton.isHidden = true
        }
        return cell
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

}
