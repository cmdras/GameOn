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
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    let friends = ["user1", "user2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("&&&&&&&&")
        print("\(userID)")
        print("&&&&&&&&")

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
