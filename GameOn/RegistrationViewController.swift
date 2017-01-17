//
//  RegistrationViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 17/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var userID: String?
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordInput.isSecureTextEntry = true
        ref = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerTouched(_ sender: Any) {
        
        if self.emailInput.text == "" || self.passwordInput.text == "" || self.userNameInput.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Please fill in all fields.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else {
            FIRAuth.auth()?.createUser(withEmail: self.emailInput.text!, password: self.passwordInput.text!, completion: { (user, error) in
                if error == nil {
                    self.userID = user!.uid
                    self.ref.child("users").child(user!.uid).setValue(["Email": user!.email])
                    self.ref.child("users").child(user!.uid).setValue(["username": self.userNameInput.text!])
                    self.ref.child("usernames").child(self.userNameInput.text!).setValue(["ID": user!.uid])
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
    
    @IBAction func cancelTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}