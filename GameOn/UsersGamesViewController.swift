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
    
    var usersGames = Array<Game>()
    let titles = ["Game1", "Game2"]
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        ref = FIRDatabase.database().reference(withPath: "users")
        self.retrieveListOfGames(ref: ref)
    }
    
    func retrieveListOfGames(ref: FIRDatabaseReference) {
        ref.child(userID).child("Games").observe(.value, with: { snapshot in
            self.usersGames.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                self.usersGames.append(self.recreateGame(dict: child.value! as! [String : String]))
            }
            self.gamesTable.reloadData()
        })
    }
    
    func recreateGame(dict: [String: String]) -> Game {
        let game = Game()
        game.title = dict["title"]
        game.releaseDate = dict["releaseDate"]
        game.coverUrl = dict["coverUrl"]
        game.summary = dict["summary"]
        return game
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTable.dequeueReusableCell(withIdentifier: "gameInfoCell", for: indexPath)
            as! GameCell
        
        cell.gameTitle.text = usersGames[indexPath.row].title
        cell.gameRelease.text = usersGames[indexPath.row].releaseDate
        if (usersGames[indexPath.row].coverUrl! != "") {
            let url = URL(string: usersGames[indexPath.row].coverUrl!)
            cell.gameImage.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "stock"), filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        } else {
            cell.gameImage.image = #imageLiteral(resourceName: "stock")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gameInfoSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.myDeleteFunction(childIWantToRemove: usersGames[indexPath.row].title!)
            self.usersGames.remove(at: indexPath.row)
            gamesTable.reloadData()
            
        }
    }
    
    func myDeleteFunction(childIWantToRemove: String) {
        
        ref.child(userID).child("Games").child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            } else {
                print("success *******")
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    


}
