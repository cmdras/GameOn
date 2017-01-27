//
//  ChatRoomVC.swift
//  GameOn
//
//  Created by Christopher Ras on 19/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Back button code adapted from http://stackoverflow.com/questions/27713747/execute-action-when-back-bar-button-of-uinavigationcontroller-is-pressed

import Firebase
import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage
import Photos

class ChatRoomVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var messages = [JSQMessage]()
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    private var updatedMessageRefHandle: FIRDatabaseHandle?
    let ref = FIRDatabase.database().reference().child("users")
    var roomRef: FIRDatabaseReference?
    var messagesRef: FIRDatabaseReference?
    var mediaRef: FIRDatabaseReference?
    let currentUser = FIRAuth.auth()?.currentUser!.uid
    let picker = UIImagePickerController()
    var myUsername: String?
    var roomID: String?
    var player: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = player
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChatRoomVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.senderId = currentUser!
        self.senderDisplayName = myUsername!
        picker.delegate = self
        
        let imgBackground:UIImageView = UIImageView(image: #imageLiteral(resourceName: "GameOnScreen"))
        imgBackground.contentMode = UIViewContentMode.scaleAspectFill
        imgBackground.clipsToBounds = true
        self.collectionView.backgroundView = imgBackground
        
        roomRef = FIRDatabase.database().reference().child("Chatrooms").child(roomID!)
        messagesRef = roomRef!.child("Messages")
        mediaRef = roomRef!.child("Media Messages")
        
        observeMessages(messagesRef: messagesRef!)
        self.scrollToBottom(animated: true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        messagesRef!.removeAllObservers()
        mediaRef!.removeAllObservers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "user_stock"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == currentUser! {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.orange)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.darkGray)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let messagesRef = FIRDatabase.database().reference().child("Chatrooms").child(roomID!)
        
        MessageHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text, messagesRef: messagesRef)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media Type", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photos = UIAlertAction(title: "Photos", style: .default, handler: {(alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        })
        
        let videos = UIAlertAction(title: "Videos", style: .default, handler: {(alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie)
        })
        alert.addAction(photos)
        alert.addAction(videos)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item]
        
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true, completion: nil)
            }
        }
    }
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaMessagesRef = FIRDatabase.database().reference().child("Chatrooms").child(roomID!)
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImageJPEGRepresentation(pic, 0.01)
            
            MessageHandler.Instance.storeMedia(image: data, video: nil, senderID: senderId, senderName: senderDisplayName, mediaMessagesRef: mediaMessagesRef)
            
        } else if let vidURL = info[UIImagePickerControllerMediaURL] as? URL {
            MessageHandler.Instance.storeMedia(image: nil, video: vidURL, senderID: senderId, senderName: senderDisplayName, mediaMessagesRef: mediaMessagesRef)
        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text))
        
        if senderID != self.senderId {
            JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            
        }
        
        collectionView.reloadData()
        self.scrollToBottom(animated: true)
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
            self.scrollToBottom(animated: true)
        }
    }
    
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        // 1
        let storageRef = FIRStorage.storage().reference(forURL: photoURL)
        
        // 2
        storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            // 3
            storageRef.metadata(completion: { (metadata, metadataErr) in
                if let error = metadataErr {
                    print("Error downloading metadata: \(error)")
                    return
                }
                
                // 4
                if (metadata?.contentType == "image/gif") {
                    mediaItem.image = UIImage.sd_animatedGIF(with: data!)
                } else {
                    mediaItem.image = UIImage.init(data: data!)
                }
                self.collectionView.reloadData()
                
                // 5
                guard key != nil else {
                    return
                }
                self.photoMessageMap.removeValue(forKey: key!)
            })
        }
    }
    

    
    func observeMessages(messagesRef: FIRDatabaseReference) {
        messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let text = data[Constants.TEXT] as? String {
                            self.messageReceived(senderID: senderID, senderName: senderName, text: text)

                        } else if let photoURL = data[Constants.URL] as? String {
                            if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: senderID == self.senderId) {
                                self.addPhotoMessage(withId: senderID, key: snapshot.key, mediaItem: mediaItem)
                                if photoURL.hasPrefix("https://") {
                                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                                    self.collectionView.reloadData()
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        updatedMessageRefHandle = messagesRef.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let photoURL = messageData[Constants.URL] as String! {
                // The photo has been updated.
                if let mediaItem = self.photoMessageMap[key] {
                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
                }
            }
        })
    }
    
    
    func back(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: ChatViewController.self) {
                _=self.navigationController?.popToViewController(aViewController, animated: true)
                
            }
        }
    }
    

}
