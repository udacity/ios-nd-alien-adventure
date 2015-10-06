//
//  OldestItemFromPlanet.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func oldestItemFromPlanet(inventory: [UDItem], planet: String) -> UDItem? {
        
        var oldestItem: UDItem? = nil
        
        let itemsToCheck = itemsFromPlanet(inventory, planet: planet)
        
        if itemsToCheck.count > 0 {
            
            for item in itemsToCheck {
                if let carbonAge = item.historicalData["CarbonAge"] as? Int {
                    
                    if let lastOldestItem = oldestItem, let lastOldestItemAge = lastOldestItem.historicalData["CarbonAge"] as? Int where lastOldestItemAge < carbonAge {
                        oldestItem = item
                    } else if oldestItem == nil {
                        oldestItem = item
                    }
                }
            }
        }
        
        return oldestItem
    }
    
}
