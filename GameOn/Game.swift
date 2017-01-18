//
//  Game.swift
//  GameOn
//
//  Created by Christopher Ras on 13/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Storage in firebase code adapted from: http://stackoverflow.com/questions/38231055/save-array-of-classes-into-firebase-database-using-swift
//

import Foundation
import Firebase
class Game {
    var title: String?
    var releaseDate: String?
    var coverUrl: String?
    var summary: String?
    var username: String?
    
    /// Saves the game in Firebase
    func saveToFirebase(myFirebase: FIRDatabaseReference) {
        let currentUser = FIRAuth.auth()!.currentUser!.uid
        let dict = ["title": self.title!, "releaseDate": self.releaseDate!, "coverUrl": self.coverUrl!, "summary": self.summary!]
        myFirebase.child("users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String
            
            myFirebase.child("users").child(currentUser).child("Games").child(self.title!.replacingOccurrences(of: ".", with: " ")).setValue(dict)
            self.addToDict(ref: myFirebase, key: self.username!, value: currentUser, gameTitle: self.title!.replacingOccurrences(of: ".", with: " "))
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    /// Function that can add a new key-value pair to an existing Firebase child
    private func addToDict(ref: FIRDatabaseReference, key: String, value: String, gameTitle: String) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("Games") {
                let gameList = snapshot.childSnapshot(forPath: "Games")
                    if gameList.hasChild(gameTitle) {
                        let gameKey = gameList.childSnapshot(forPath: gameTitle)
                        let dict = gameKey.value as! NSDictionary
                        let newDict = dict as! NSMutableDictionary
                        newDict[key] = value
                        ref.child("Games").child(gameTitle).setValue(newDict)
                    } else {
                        ref.child("Games").child(gameTitle).setValue([key: value])
                    }
            } else {
                ref.child("Games").child(gameTitle).setValue([key: value])
            }
        })
    }
    
}
