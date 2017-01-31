//
//  Constants.swift
//  GameOn
//
//  Created by Christopher Ras on 23/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  Idea from Awesome Tuts on Youtube: https://www.youtube.com/channel/UC5c-DuzPdH9iaWYdI0v0uzw
//  A Constants class which contains strings to be used in other Controllers.
//  The idea behind this is that if a string is used multiple times, having a constant will make it easier to change the string everywhere if necessary. It also prevents typo's, as the constant string will be shown in the autocomplete section in Xcode.

import Foundation

class Constants {
    // ref strings
    static let USERS = "users"
    static let GAMES = "Games"
    static let USERNAMES = "usernames"
    static let PROFILE_PICTURES = "Profile_Pictures"
    static let CHATROOMS = "Chatrooms"
    static let FOLLOWING_PLAYERS = "Following Players"
    static let MESSAGES = "Messages"
    static let MEDIA_MESSAGES = "Media Messages"
    
    // Game attributes
    static let TITLE = "title"
    static let RELEASE_DATE = "releaseDate"
    static let COVER_URL = "coverUrl"
    static let SUMMARY = "summary"
    
    // messages
    static let TEXT = "text"
    static let SENDER_ID = "sender_id"
    static let SENDER_NAME = "sender_name"
    static let URL = "url"
}
