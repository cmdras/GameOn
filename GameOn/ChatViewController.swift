//
//  ChatViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Pop to specific view adapted from: http://stackoverflow.com/questions/26132658/pop-2-view-controllers-in-nav-controller-in-swift
//
//  In this View, the user can see in which open chats the user is participating in. By touching an open chat, that chatroom is opened. Otherwise the user can open a new chat with someone the user is following.

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    let username = FIRAuth.auth()!.currentUser!.displayName
    var roomKeys = [String]()
    var openChats = [String: String]()
    var selectedRoomID: String?
    var selectedPlayer: String?
    
    // MARK: - Outlets
    @IBOutlet weak var chatListTable: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let userRef = FIRDatabase.database().reference().child(Constants.USERS).child(userID)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        retrieveOpenChats(ref: userRef)
        self.title = "My Chatrooms"
    }
    
    // MARK: - Helper Functions
    func retrieveOpenChats(ref: FIRDatabaseReference) {
        ref.observe(.value, with: { (snapshot) in
            if snapshot.hasChild(Constants.CHATROOMS) {
                let chatRoomRef = snapshot.childSnapshot(forPath: Constants.CHATROOMS)
                let chatrooms = chatRoomRef.value as! NSDictionary
                for room in chatrooms.allKeys {
                    let roomInfo = chatrooms[room] as? [String: String]
                    for roomKey in roomInfo!.keys {
                        self.openChats[roomKey] = roomInfo![roomKey]
                    }
                }
                self.chatListTable.reloadData()
            }
        })
        
    }
    
    // MARK: - Table View Handling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openChats.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTable.dequeueReusableCell(withIdentifier: "chatUserCell", for: indexPath)
            as! ChatListCell
        
        roomKeys = [String] (openChats.keys)
        cell.username.text = roomKeys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatListTable.deselectRow(at: indexPath, animated: true)
        selectedPlayer = roomKeys[indexPath.row]
        selectedRoomID = openChats[selectedPlayer!]
        performSegue(withIdentifier: "openChatSegue", sender: nil)
    }
    
    // MARK: IBAction functions
    @IBAction func newChatTouched(_ sender: Any) {
        performSegue(withIdentifier: "newChatSegue", sender: nil)
    }
    
    @IBAction func logOutTouched(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.animateToDestinationController(storyboardId: "LoginViewController")
        }
    }
    
    // Segue Preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatUsersVC = segue.destination as? PlayersViewController {
            chatUsersVC.segueType = "New Chat"
        } else if let chatVC = segue.destination as? ChatRoomVC {
            chatVC.player = selectedPlayer
            chatVC.roomID = selectedRoomID
            chatVC.myUsername = username
        }
    }
}
