//
//  LoginViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 10/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class LoginViewController: UIViewController {
    var ref: FIRDatabaseReference!
    var userID: String?

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.userID = user!.uid
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
        self.passwordText.isSecureTextEntry = true
        ref = FIRDatabase.database().reference()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.emailText.text == "" || self.passwordText.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.emailText.text!, password: self.passwordText.text!, completion: { (user, error) in
                if error == nil {
                    self.userID = user!.uid
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
