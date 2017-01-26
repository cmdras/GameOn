//
//  PlayersViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

typealias chatroomExistsComplete = (Bool, String?) -> ()

class PlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var friendListTable: UITableView!
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    let chatRoomRef = FIRDatabase.database().reference().child("Chatrooms")
    let userID = FIRAuth.auth()!.currentUser!.uid
    var userRef: FIRDatabaseReference?
    var roomID: String?
    var segueType = ""
    var friends = [String:String]()
    var friendKeys: [String]?
    var username: String?
    var selectedUsername: String?
    var selectedUserId: String?
    var chatAlreadyExists: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        if segueType != "New Chat" {
            segueType = "Game List"
        }
        self.title = "Followed Players"
        userRef = ref.child(userID)
        //myOpenChatRoomsRef = userRef.child("Chatrooms")
        retrieveListOfFriends(ref: userRef!)
        getUsername(ref: ref, currentUser: userID)
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
            chatroomExists(playerUsername: selectedUsername!, completion: { (exists, chatroomID) in
                if exists {
                    self.roomID = chatroomID
                    self.performSegue(withIdentifier: "openChatSegue", sender: nil)
                }
                if self.roomID == nil {
                    self.roomID = self.createNewChat(playerUsername: self.selectedUsername!, playerUserId: self.selectedUserId!)
                    self.performSegue(withIdentifier: "openChatSegue", sender: nil)
                }
                
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueType == "Game List" {
            if let gamesVC = segue.destination as? FollowedPlayersGamesViewController {
                gamesVC.username = self.selectedUsername
                gamesVC.userID = self.selectedUserId
            }
        } else if segueType == "New Chat" {
            if let chatVC = segue.destination as? ChatRoomVC {
                chatVC.roomID = self.roomID!
                chatVC.player = self.selectedUsername
                chatVC.myUsername = self.username
            }
        }
    }
        
    
    @IBAction func logOutTouched(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func getUsername(ref: FIRDatabaseReference, currentUser: String) {
        ref.child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String
        })
    }
    
    func chatroomExists(playerUsername: String, completion: @escaping chatroomExistsComplete) {
        userRef!.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild("Chatrooms") {
                let myOpenChatRoomsRef = snapshot.childSnapshot(forPath: "Chatrooms")
                let openChats = myOpenChatRoomsRef.value as? NSDictionary
                let keys = openChats!.allKeys
                for key in keys {
                    let chatRoom = openChats?[key] as? NSDictionary
                    if let chatParticipant = chatRoom?.allKeys[0] as? String {
                        if chatParticipant == playerUsername {
                            completion(true, chatRoom?[chatParticipant] as? String)
                        }
                    }
                }
                
                completion(false, nil)
            } else {
                completion(false, nil)
            }
        })
        
    }
    
    func createNewChat(playerUsername: String, playerUserId: String) -> String{
        let newChatRoomRef = chatRoomRef.childByAutoId()
        newChatRoomRef.setValue(["Chat participants": [username!, playerUsername]])
        ref.child(userID).child("Chatrooms").childByAutoId().setValue([playerUsername:newChatRoomRef.key])
        ref.child(playerUserId).child("Chatrooms").childByAutoId().setValue([username!:newChatRoomRef.key])
        return newChatRoomRef.key
    }

}
