//
//  MessageHandler.swift
//  GameOn
//
//  Created by Christopher Ras on 23/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Adapted from https://www.youtube.com/watch?v=A5xxGXUfpBM

import Foundation

class MessageHandler {
    private static let _instance = MessageHandler()
    private init() {}
    
    static var Instance: MessageHandler {
        return _instance
    }
    
    func sendMessage(senderID: String, senderName: String, text: String) {
        let data: [String: Any] = [Constants.SENDER_ID: senderID, Constants.SENDER_NAME: senderName, Constants.TEXT: text]
        
        
    }
    
}
