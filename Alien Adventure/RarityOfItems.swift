//
//  RarityOfItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func rarityOfItems(inventory: [UDItem]) -> [UDItemRarity:Int] {
        
        var numberOfItemsWithRarity = [UDItemRarity:Int]()
        
        if inventory.count > 0 {
            
            for item in inventory {
                if let _ = numberOfItemsWithRarity[item.rarity] {
                    numberOfItemsWithRarity[item.rarity]! += 1
                } else {
                    numberOfItemsWithRarity[item.rarity] = 1
                }
            }
        }
        
        return numberOfItemsWithRarity
    }
}
