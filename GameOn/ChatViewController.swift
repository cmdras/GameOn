//
//  ChatViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var chatListTable: UITableView!
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    var myChatsRef: FIRDatabaseReference?
    var roomKeys = [String]()
    var openChats = [String: String]()
    var selectedRoomID: String?
    var selectedPlayer: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let userRef = FIRDatabase.database().reference().child("users").child(userID)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        retrieveOpenChats(ref: userRef)
        
    }
    
    func retrieveOpenChats(ref: FIRDatabaseReference) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("Chatrooms") {
                let chatRoomRef = snapshot.childSnapshot(forPath: "Chatrooms")
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
    
    @IBAction func newChatTouched(_ sender: Any) {
        performSegue(withIdentifier: "newChatSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatUsersVC = segue.destination as? PlayersViewController {
            chatUsersVC.segueType = "New Chat"
        } else if let chatVC = segue.destination as? ChatRoomVC {
            chatVC.chatWith = selectedPlayer
            chatVC.roomID = selectedRoomID
        }
    }

}
