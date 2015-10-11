//
//  ItemComparison.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

func <(lhs: UDItem, rhs: UDItem) -> Bool {
    if lhs.rarity.rawValue > rhs.rarity.rawValue {
        return false
    } else if lhs.rarity.rawValue == rhs.rarity.rawValue {
        return lhs.baseValue < rhs.baseValue
    } else {
        return true
    }
}