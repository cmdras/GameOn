//
//  UsersGamesViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Delete functionality adapted from: http://stackoverflow.com/questions/39631998/how-to-delete-from-firebase-database

import UIKit
import Firebase

class UsersGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var gamesTable: UITableView!
    
    var usersGames = Array<Game>()
    let userID: String = FIRAuth.auth()!.currentUser!.uid
    let username = FIRAuth.auth()!.currentUser!.displayName
    var ref: FIRDatabaseReference!
    var gamesRef: FIRDatabaseReference!
    
    var selectedGame: Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        ref = FIRDatabase.database().reference(withPath: "users")
        gamesRef = FIRDatabase.database().reference(withPath: "Games")
        self.retrieveListOfGames(ref: ref)
        self.title = "My Games"
    }
    
    func retrieveListOfGames(ref: FIRDatabaseReference) {
        ref.child(userID).child("Games").observe(.value, with: { snapshot in
            self.usersGames.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                self.usersGames.append(self.recreateGame(dict: child.value! as! [String : String]))
            }
            print("New data added")
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
        self.selectedGame = usersGames[indexPath.row]
        gamesTable.deselectRow(at: indexPath, animated: true)
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
        
        ref.child(userID).child("Games").child(childIWantToRemove.replacingOccurrences(of: ".", with: " ")).removeValue { (error, ref) in
            if error != nil {
                let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        gamesRef.child(childIWantToRemove.replacingOccurrences(of: ".", with: " ")).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let newDict = value as? NSMutableDictionary
            newDict?[self.username!] = nil
            self.gamesRef.child(childIWantToRemove.replacingOccurrences(of: ".", with: " ")).setValue(newDict!)
        
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoVC = segue.destination as? GameInfoViewController {
            infoVC.selectedGame = self.selectedGame
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        try! FIRAuth.auth()!.signOut()
        dismiss(animated: true, completion: nil)
    }
}
