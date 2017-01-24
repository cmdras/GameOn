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
import AlamofireImage

class ChatRoomVC: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var messages = [JSQMessage]()
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
        
        MessageHandler.Instance.delegate = self
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
        MessageHandler.Instance.observeMessages(messagesRef: messagesRef!)
        MessageHandler.Instance.observeMediaMessages(messagesRef: mediaRef!)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        roomRef!.removeAllObservers()
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
        collectionView.reloadData()
    }
    
    func mediaReceived(senderID: String, senderName: String, url: String) {
        if let mediaURL = URL(string: url) {
            do {
                let data = try Data(contentsOf: mediaURL)
                if let _ = UIImage(data: data) {
                    let downloader = ImageDownloader()
                    let urlRequest = URLRequest(url: URL(string: url)!)
                    
                    print(mediaURL)
                    
                    downloader.download(urlRequest) { response in
                        print("start download")
                        if let image = response.result.value {
                            print(image)
                            let photo = JSQPhotoMediaItem(image: image)
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo))
                            
                            print("image finished downloading")
                        } else {
                            print("somethings up")
                        }
                        self.collectionView.reloadData()
                        print("collection view reloaded")
                    }
                }
            } catch {
                // errors
            }
        }
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
