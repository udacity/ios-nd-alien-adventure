//
//  ItemsFromPlanet.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func itemsFromPlanet(inventory: [UDItem], planet: String) -> [UDItem] {
        
        var items = [UDItem]()
        
        if inventory.count > 0 {
            
            for item in inventory {
                if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String where planetOfOrigin == planet {
                    items.append(item)
                }
            }
        }
        
        return items
    }
    
}
