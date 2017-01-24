//
//  MessageHandler.swift
//  GameOn
//
//  Created by Christopher Ras on 23/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Adapted from https://www.youtube.com/watch?v=A5xxGXUfpBM

import Foundation
import Firebase

protocol MessageReceivedDelegate: class {
    func messageReceived(senderID: String, senderName: String, text: String)
    func mediaReceived(senderID: String, senderName: String, url: String)
}

class MessageHandler {
    private static let _instance = MessageHandler()
    private init() {}
    
    weak var delegate: MessageReceivedDelegate?
    
    static var Instance: MessageHandler {
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, text: String, messagesRef: FIRDatabaseReference) {
        let data: [String: Any] = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text]
        messagesRef.child("Messages").childByAutoId().setValue(data)
    }
    
    func sendMediaMesage(senderID: String, senderName: String, url: String, mediaMessagesRef: FIRDatabaseReference) {
        let data = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.URL: url]
        
        mediaMessagesRef.child("Media Messages").childByAutoId().setValue(data)
    }
    
    func storeMedia(image: Data?, video: URL?, senderID: String, senderName: String, mediaMessagesRef: FIRDatabaseReference) {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://game-on-11c52.appspot.com")
        
        if image != nil {
            let imageStorageRef = storageRef.child("Image_Storage")
            imageStorageRef.child(senderID + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil) {( metadata: FIRStorageMetadata?,  err: Error?) in
                
                if err != nil {
                    // error
                } else {
                    self.sendMediaMesage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!), mediaMessagesRef: mediaMessagesRef)
                }
            
            }
        } else if video != nil {
            let videoStorageRef = storageRef.child("Video_Storage")
            videoStorageRef.child(senderID + "\(NSUUID().uuidString)").putFile(video!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    // error
                } else {
                    self.sendMediaMesage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!), mediaMessagesRef: mediaMessagesRef)
                }
            
            }
        }
        
    }
    
    func observeMessages(messagesRef: FIRDatabaseReference) {
        messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.SENDER_ID] as? String {
                    if let senderName = data[Constants.SENDER_NAME] as? String {
                        if let text = data[Constants.TEXT] as? String {
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text)
                        }
                    }
                    
                }
            }
        }
    }
    
    func observeMediaMessages(messagesRef: FIRDatabaseReference) {
        messagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let id = data[Constants.SENDER_ID] as? String {
                    if let name = data[Constants.SENDER_NAME] as? String {
                        if let fileURL = data[Constants.URL] as? String {
                            self.delegate?.mediaReceived(senderID: id, senderName: name, url: fileURL)
                        }
                    }
                }
            }
        }
    }
    
}
