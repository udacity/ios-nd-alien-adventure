//
//  UDItem.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/28/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDItemType

enum UDItemType: Int {
    case Weapon = 0, Magic, Other
}

// MARK: - UDItemRarity

enum UDItemRarity: Int {
    case Common = 0, Uncommon, Rare, Legendary
}

// MARK: - UDItem

struct UDItem {
    
    // MARK: Properties
    
    var itemID: Int
    var itemType: UDItemType
    var name: String
    var baseValue: Int
    var inscription: String?
    var rarity: UDItemRarity
    var historicalData: [String:AnyObject]
    
    // MARK: Initializer
    
    init(itemID: Int, itemType: UDItemType, name: String, baseValue: Int, inscription: String? = nil, rarity: UDItemRarity, historicalData: [String:AnyObject]) {
        self.itemID = itemID
        self.itemType = itemType
        self.name = name
        self.baseValue = baseValue
        self.inscription = inscription
        self.rarity = rarity
        self.historicalData = historicalData
    }
}

// MARK: - UDItem: Hashable

extension UDItem: Hashable {
    var hashValue: Int {
        return itemID.hashValue
    }
}


// MARK: - UDItem (Operators)

func <= (lhs: UDItem, rhs: UDItem) -> Bool {
    if lhs.rarity.rawValue > rhs.rarity.rawValue {
        return false
    } else if lhs.rarity.rawValue == rhs.rarity.rawValue {
        return lhs.baseValue <= rhs.baseValue
    } else {
        return true
    }
}

func == (lhs: UDItem, rhs: UDItem) -> Bool {
    return lhs.itemID == rhs.itemID
}

func != (lhs: UDItem, rhs: UDItem) -> Bool {
    return !(lhs == rhs)
}