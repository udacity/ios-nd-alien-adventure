//
//  BannedItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

extension Hero {
    
    func bannedItems(dataFile: String) -> [Int] {
        
        let itemsListURL = NSBundle.mainBundle().URLForResource("ItemList", withExtension: "plist")!
        
        let itemsArray = NSArray(contentsOfURL: itemsListURL) as! [[String:AnyObject]]
        
        var bannedItemIDs = [Int]()
        
        for item in itemsArray {
            guard let itemID = item["ItemID"] as? Int else {
                continue
            }
            
            if let name = item["Name"] as? String where name.lowercaseString.containsString("laser") {
                
                if let historicalData = item["HistoricalData"] as? [String:AnyObject], let carbonAge = historicalData["CarbonAge"] as? Int where carbonAge < 30 {
                    bannedItemIDs.append(itemID)
                }
            }
        }
        
        return bannedItemIDs
    }
}

