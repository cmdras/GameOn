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
    
}
