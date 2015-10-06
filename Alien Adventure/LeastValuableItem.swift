//
//  LeastValuableItem.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func leastValuableItem(inventory: [UDItem]) -> UDItem? {
        
        var leastValuableItem: UDItem? = nil
        
        if inventory.count > 0 {
            
            leastValuableItem = inventory[0]
            
            for item in inventory {
                if item.baseValue < leastValuableItem!.baseValue {
                    leastValuableItem = item
                }
            }
        }
        
        return leastValuableItem
    }
}
