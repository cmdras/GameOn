//
//  ChatViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 11/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    let userID: String = FIRAuth.auth()!.currentUser!.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        print("+++++++")
        print("\(userID)")
        print("+++++++")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
