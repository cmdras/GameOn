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
    var segueType = ""
    var friends = [String:String]()
    var friendKeys: [String]?
    var selectedUsername: String?
    var selectedUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if segueType != "New Chat" {
            segueType = "Game List"
        }
        self.title = "Followed Players"
        let userRef = ref.child(userID)
        retrieveListOfFriends(ref: userRef)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false

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
        self.friendKeys = [String](friends.keys)
        cell.username.text = self.friendKeys![indexPath.row]
        cell.profileImage.image = #imageLiteral(resourceName: "user_stock")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendListTable.deselectRow(at: indexPath, animated: true)
        self.selectedUsername = self.friendKeys![indexPath.row]
        self.selectedUserId = self.friends[self.selectedUsername!]
        if segueType == "Game List" {
            performSegue(withIdentifier: "followedPlayerSegue", sender: nil)
        } else if segueType == "New Chat" {
            performSegue(withIdentifier: "openChatSegue", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueType == "Game List" {
            if let gamesVC = segue.destination as? FollowedPlayersGamesViewController {
                gamesVC.username = self.selectedUsername
                gamesVC.userID = self.selectedUserId
            }
        } else if segueType == "New Chat" {
            print("Wooo")
        }
    }
        
    
    @IBAction func logOutTouched(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }
    

}
