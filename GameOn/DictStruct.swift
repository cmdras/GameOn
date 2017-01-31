//
//  DictStruct.swift
//  GameOn
//
//  Created by Christopher Ras on 31/01/2017.
//  Copyright © 2017 Chris Ras. All rights reserved.
//
//  A struct to be used by the Game class, so that less parameters are needed in the addToDict function


import Foundation

struct DictStruct {
    let key, value, gameTitle: String
    init(key: String, value: String, gameTitle: String) {
        self.key = key
        self.value = value
        self.gameTitle = gameTitle
    }
}
