//
//  RegistrationViewController.swift
//  GameOn
//
//  Created by Christopher Ras on 17/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Gesture recognizer code adapted from: http://stackoverflow.com/questions/29202882/how-to-you-make-a-uiimageview-on-the-storyboard-clickable-swift

import UIKit
import Firebase

typealias imageUploaded = () -> ()

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    let stockURL = "https://firebasestorage.googleapis.com/v0/b/game-on-11c52.appspot.com/o/Profile_Pictures%2Fuser_stock.png?alt=media&token=d5f91d45-bf31-44d7-af92-ac734a1bdfff"
    let imagePicker = UIImagePickerController()
    var selectedProfileImage: String?
    
    // MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordInput.isSecureTextEntry = true
        ref = FIRDatabase.database().reference()
        imagePicker.delegate = self
        profileImage.image = #imageLiteral(resourceName: "user_stock")
        makeImageTouchable(imageView: profileImage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
    // MARK: - IBAction Functions
    @IBAction func registerTouched(_ sender: Any) {
        
        if self.emailInput.text == "" || self.passwordInput.text == "" || self.userNameInput.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Please fill in all fields.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else {
            ref.child(Constants.USERNAMES).observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.hasChild(self.userNameInput.text!)) {
                    let alertController = UIAlertController(title: "Oops", message: "Username already taken. Try a different username.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.userNameInput.text = ""
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: self.emailInput.text!, password: self.passwordInput.text!, completion: { (user, error) in
                        if error == nil {
                            self.ref.child(Constants.USERS).child(user!.uid).setValue(["username": self.userNameInput.text!])
                            
                            let changeRequest = user?.profileChangeRequest()
                            changeRequest?.displayName = self.userNameInput.text
                            if self.profileImage.image == #imageLiteral(resourceName: "user_stock") {
                                changeRequest?.photoURL = URL(string: self.stockURL)
                                self.commitChangesToFirebase(user: user, changeRequest: changeRequest)
                            } else {
                                self.uploadProfileImageToFirebase(user: user!, completion: {
                                    changeRequest?.photoURL = URL(string: self.selectedProfileImage!)
                                    self.commitChangesToFirebase(user: user, changeRequest: changeRequest)
                                })
                            }
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        } else {
                            let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })

                }
            })
        }
        
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func imageTapped(gesture: UIGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func uploadProfileImageToFirebase(user: FIRUser, completion: @escaping imageUploaded) {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://game-on-11c52.appspot.com")
        var data = Data()
        data = UIImagePNGRepresentation(profileImage.image!)!
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/png"
        
        storageRef.child(Constants.PROFILE_PICTURES).child(user.uid).put(data, metadata: metaData) {(metaData, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return
            } else {
                self.selectedProfileImage = metaData!.downloadURL()!.absoluteString
                completion()
            }
        }
    }
    
    func makeImageTouchable(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage.contentMode = .scaleAspectFit
            self.profileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func commitChangesToFirebase(user: FIRUser?,changeRequest: FIRUserProfileChangeRequest?) {
        changeRequest?.commitChanges { error in
            if let error = error {
                let alertController = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.ref.child(Constants.USERNAMES).child(user!.displayName!).setValue(["ID": user!.uid, "ProfileImage": "\(user!.photoURL!)"])
            }
        }
    }
    
    
    
}
