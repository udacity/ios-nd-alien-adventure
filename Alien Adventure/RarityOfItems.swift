//
//  RarityOfItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func rarityOfItems(inventory: [UDItem]) -> [UDItemRarity:Int] {
        
        var numberOfItemsWithRarity: [UDItemRarity:Int] = [
            .Common: 0,
            .Uncommon: 0,
            .Rare: 0,
            .Legendary: 0
        ]
        
        if inventory.count > 0 {            
            for item in inventory {
                numberOfItemsWithRarity[item.rarity]! += 1
            }
        }
        
        return numberOfItemsWithRarity
    }
}
