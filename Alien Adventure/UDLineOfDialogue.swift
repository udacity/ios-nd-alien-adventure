//
//  UDLineOfDialogue.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDLineSource

enum UDLineSource: Int {
    case hero = 0, alien, none
}

// MARK: - UDLineOfDialogue

struct UDLineOfDialogue {
    
    // MARK: Properties
    
    var lineText: String
    var lineSource: UDLineSource
}
