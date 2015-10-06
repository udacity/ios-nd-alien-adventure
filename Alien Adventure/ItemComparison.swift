//
//  ItemComparison.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

func <(lhs: UDItem, rhs: UDItem) -> Bool {
    if lhs.rarity.rawValue < rhs.rarity.rawValue {
        return true
    } else if rhs.rarity.rawValue < lhs.rarity.rawValue {
        return false
    } else {
        return lhs.baseValue < rhs.baseValue
    }
}