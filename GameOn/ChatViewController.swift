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
    let users = ["user1", "user2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("+++++++")
        print("\(userID)")
        print("+++++++")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTable.dequeueReusableCell(withIdentifier: "chatUserCell", for: indexPath)
            as! ChatListCell
        cell.username.text = users[indexPath.row]
        return cell
    }
    

}