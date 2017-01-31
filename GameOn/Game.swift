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
        let dict = [Constants.TITLE: self.title!, Constants.RELEASE_DATE: self.releaseDate!, Constants.COVER_URL: self.coverUrl!, Constants.SUMMARY: self.summary!]
        myFirebase.child(Constants.USERS).child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String
            
            myFirebase.child(Constants.USERS).child(currentUser).child(Constants.GAMES).child(self.title!.replacingOccurrences(of: ".", with: " ")).setValue(dict)
            
            let gameStruct = DictStruct(key: self.username!, value: currentUser, gameTitle: self.title!.replacingOccurrences(of: ".", with: " "))
            self.addToDict(ref: myFirebase, valueStruct: gameStruct)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    /// Function that can add a new key-value pair to an existing Firebase child
    private func addToDict(ref: FIRDatabaseReference, valueStruct: DictStruct) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(Constants.GAMES) {
                let gameList = snapshot.childSnapshot(forPath: Constants.GAMES)
                    if gameList.hasChild(valueStruct.gameTitle) {
                        let gameKey = gameList.childSnapshot(forPath: valueStruct.gameTitle)
                        let dict = gameKey.value as! NSDictionary
                        let newDict = dict as! NSMutableDictionary
                        newDict[valueStruct.key] = valueStruct.value
                        ref.child(Constants.GAMES).child(valueStruct.gameTitle).setValue(newDict)
                    } else {
                        ref.child(Constants.GAMES).child(valueStruct.gameTitle).setValue([valueStruct.key: valueStruct.value])
                    }
            } else {
                ref.child(Constants.GAMES).child(valueStruct.gameTitle).setValue([valueStruct.key: valueStruct.value])
            }
        })
    }
    
}
