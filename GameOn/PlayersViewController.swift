//
//  PlayersViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class PlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var friendListTable: UITableView!
    var ref: FIRDatabaseReference!
    
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    var friends = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followed Players"
        
        ref = FIRDatabase.database().reference(withPath: "usernames")
        retrieveListOfGames(ref: ref)
        self.navigationItem.hidesBackButton = true

    }
    
    func retrieveListOfGames(ref: FIRDatabaseReference) {
        ref.observe(.value, with: { snapshot in
            self.friends.removeAll()
            self.friends = ((snapshot.value! as? NSDictionary)?.allKeys as? [String])!
            self.friendListTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendListTable.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath)
            as! FriendCell
        cell.username.text = friends[indexPath.row]
        return cell
    }
    

}
