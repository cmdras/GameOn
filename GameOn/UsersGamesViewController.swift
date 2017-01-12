//
//  UsersGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class UsersGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var gamesTable: UITableView!
    
    
    let titles = ["Overwatch", "Mario"]
    let userID: String = FIRAuth.auth()!.currentUser!.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        print("*********")
        print("\(userID)")
        print("*********")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTable.dequeueReusableCell(withIdentifier: "gameInfoCell", for: indexPath)
            as! GameCell
        
        cell.gameTitle.text = titles[indexPath.row]
        return cell
    }
    
    


}
