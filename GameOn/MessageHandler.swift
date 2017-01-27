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

class MessageHandler {
    private static let _instance = MessageHandler()
    private init() {}
    
    static var Instance: MessageHandler {
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, text: String, messagesRef: FIRDatabaseReference) {
        let data: [String: Any] = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text]
        messagesRef.child("Messages").childByAutoId().setValue(data)
    }
    
    func sendMediaMesage(senderID: String, senderName: String, url: String, messagesRef: FIRDatabaseReference) {
        let data = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.URL: url]
        
        messagesRef.child("Messages").childByAutoId().setValue(data)
    }
    
    func storeMedia(image: Data?, video: URL?, senderID: String, senderName: String, mediaMessagesRef: FIRDatabaseReference) {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://game-on-11c52.appspot.com")
        
        if image != nil {
            let imageStorageRef = storageRef.child("Image_Storage")
            imageStorageRef.child(senderID + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil) {( metadata: FIRStorageMetadata?,  err: Error?) in
                
                if err != nil {
                    // error
                } else {
                    self.sendMediaMesage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!), messagesRef: mediaMessagesRef)
                }
            
            }
        } else if video != nil {
            let videoStorageRef = storageRef.child("Video_Storage")
            videoStorageRef.child(senderID + "\(NSUUID().uuidString)").putFile(video!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                if err != nil {
                    // error
                } else {
                    self.sendMediaMesage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!), messagesRef: mediaMessagesRef)
                }
            
            }
        }
        
    }
    
}
