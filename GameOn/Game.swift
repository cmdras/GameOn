//
//  Classes.swift
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
    
    func saveToFirebase(myFirebase: FIRDatabaseReference) {
        let currentUser = FIRAuth.auth()!.currentUser!.uid
        let dict = ["title": self.title!, "releaseDate": self.releaseDate!, "coverUrl": self.coverUrl!, "summary": self.summary!]
        myFirebase.child("users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String
            
            myFirebase.child("users").child(currentUser).child("Games").child(self.title!.replacingOccurrences(of: ".", with: " ")).setValue(dict)
            myFirebase.child("Games").child(self.title!.replacingOccurrences(of: ".", with: " ")).child(self.username!).setValue(currentUser)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
