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
    
    func saveToFirebase(myFirebase: FIRDatabaseReference) {
        let dict = ["title": self.title!, "releaseDate": self.releaseDate!, "coverUrl": self.coverUrl!, "summary": self.summary!]
        
        myFirebase.child(FIRAuth.auth()!.currentUser!.uid).child("Games").child(self.title!).setValue(dict)
    }
    
}
