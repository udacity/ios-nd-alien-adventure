//
//  BoostItemValue.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func boostItemValue(inventory: [UDItem]) -> [UDItem] {
        return inventory.map({ UDItem(itemID: $0.itemID, itemType: $0.itemType, name: $0.name, baseValue: $0.baseValue + 100, inscription: $0.inscription, rarity: $0.rarity, historicalData: $0.historicalData) })
    }
}