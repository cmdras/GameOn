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
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    let userID = FIRAuth.auth()!.currentUser!.uid
    var friends = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followed Players"
        let userRef = ref.child(userID)
        retrieveListOfFriends(ref: userRef)
        self.navigationItem.hidesBackButton = true

    }
    
    func retrieveListOfFriends(ref: FIRDatabaseReference) {
        ref.observe(.value, with: { snapshot in
            if snapshot.hasChild("Following Players") {
                let followedDict = snapshot.childSnapshot(forPath: "Following Players")
                self.friends.removeAll()
                self.friends = followedDict.value! as! [String:String]
                self.friendListTable.reloadData()
            }
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
        let friendKeys = [String](friends.keys)
        cell.username.text = friendKeys[indexPath.row]
        return cell
    }
    

}
