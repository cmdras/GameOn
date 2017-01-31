//
//  PlayersViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  This View shows which players the user is currently following. By pressing on a player, the user can see which games the user is playing.

import UIKit
import Firebase

typealias chatroomExistsComplete = (Bool, String?) -> ()
typealias imageURLRetrieved = (String?) -> ()

class PlayersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    let username = FIRAuth.auth()!.currentUser!.displayName
    let userID = FIRAuth.auth()!.currentUser!.uid
    var ref: FIRDatabaseReference!
    var chatRoomRef: FIRDatabaseReference!
    var usernamesRef: FIRDatabaseReference!
    var imageURLS = [String]()
    var userRef: FIRDatabaseReference?
    var roomID: String?
    var segueType = ""
    var friends = [String:Any]()
    var friendKeys: [String]?
    var selectedUsername: String?
    var selectedUserId: String?
    var chatAlreadyExists: Bool?
    
    // MARK: - Outlets
    @IBOutlet weak var friendListTable: UITableView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(withPath: Constants.USERS)
        chatRoomRef = FIRDatabase.database().reference().child(Constants.CHATROOMS)
        usernamesRef = FIRDatabase.database().reference().child(Constants.USERNAMES)
        
        if segueType != "New Chat" {
            segueType = "Game List"
        }
        
        self.title = "Followed Players"
        userRef = ref.child(userID)
        retrieveListOfFriends(ref: userRef!)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helper Functions
    func retrieveListOfFriends(ref: FIRDatabaseReference) {
        ref.observe(.value, with: { snapshot in
            if snapshot.hasChild(Constants.FOLLOWING_PLAYERS) {
                let followedDict = snapshot.childSnapshot(forPath: Constants.FOLLOWING_PLAYERS)
                self.friends.removeAll()
                self.friends = followedDict.value! as! [String:Any]
                self.friendKeys = [String](self.friends.keys)
                self.friendListTable.reloadData()
            }
        })
    }
    
    /// Checks if a chatroom between two players already exists or not
    func chatroomExists(playerUsername: String, completion: @escaping chatroomExistsComplete) {
        userRef!.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild(Constants.CHATROOMS) {
                let myOpenChatRoomsRef = snapshot.childSnapshot(forPath: Constants.CHATROOMS)
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
        ref.child(userID).child(Constants.CHATROOMS).childByAutoId().setValue([playerUsername:newChatRoomRef.key])
        ref.child(playerUserId).child(Constants.CHATROOMS).childByAutoId().setValue([username!:newChatRoomRef.key])
        return newChatRoomRef.key
    }
    
    // MARK: - Table View Handling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendListTable.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath)
            as! FriendCell
        
        cell.username.text = self.friendKeys![indexPath.row]
        let userInfo = self.friends[cell.username.text!] as! NSDictionary
        let url = URL(string: (userInfo["image"] as! String))
        cell.profileImage.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "user_stock"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendListTable.deselectRow(at: indexPath, animated: true)
        self.selectedUsername = self.friendKeys![indexPath.row]
        let userInfo = self.friends[self.selectedUsername!] as! NSDictionary
        self.selectedUserId = userInfo["ID"] as? String
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
    
    // MARK: - IBAction functions
    @IBAction func logOutTouched(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.animateToDestinationController(storyboardId: "LoginViewController")
        }
    }
    
    // MARK: - Segue Preparation
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

}
