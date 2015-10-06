//
//  ReverseLongestName.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func reverseLongestName(inventory: [UDItem]) -> String {
        
        var longestString = ""
        
        if inventory.count > 0 {
            
            for item in inventory {
                if item.name.characters.count > longestString.characters.count {
                    longestString = item.name
                }
            }
        }

        return String(longestString.characters.reverse())
    }
    
}