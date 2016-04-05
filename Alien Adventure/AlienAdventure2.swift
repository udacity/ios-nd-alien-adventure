//
//  AlienAdventure2.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - RequestTester (Alien Adventure 2 Tests)

extension UDRequestTester {
    
    // MARK: ItemsFromPlanet
    
    func testItemsFromPlanet() -> Bool {
        
        // check 1
        let itemsFromCheck1 = delegate.handleItemsFromPlanet([UDItem](), planet: "Glinda")
        if itemsFromCheck1.count != 0 {
            print("ItemsFromPlanet FAILED: If the inventory is empty, then the number of items returned should be 0.")
            return false
        }
        
        // check 2
        let itemsFromCheck2 = delegate.handleItemsFromPlanet(allItems(), planet: "Glinda")
        var glindaCount2 = 0
        for item in itemsFromCheck2 {
            if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String {
                if planetOfOrigin == "Glinda" {
                    glindaCount2 += 1
                } else {
                    print("ItemsFromPlanet FAILED: An item not from Glinda was returned.")
                    return false
                }
            }
        }
        if glindaCount2 != 3 {
            print("ItemsFromPlanet FAILED: The number of items from Glinda is not correct.")
            return false
        }
        
        // check 3
        let itemsFromCheck3 = delegate.handleItemsFromPlanet(delegate.inventory, planet: "Glinda")
        var glindaCount3 = 0
        for item in itemsFromCheck3 {
            if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String {
                if planetOfOrigin == "Glinda" {
                    glindaCount3 += 1
                } else {
                    print("ItemsFromPlanet FAILED: An item not from Glinda was returned.")
                    return false
                }
            }
        }
        if glindaCount3 != 4 {
            print("ItemsFromPlanet FAILED: The number of items from Glinda is not correct.")
            return false
        }
        
        // check 4 (ensure student isn't hard-coding the "Glinda" check
        let itemsFromCheck4 = delegate.handleItemsFromPlanet(delegate.inventory, planet: "Cunia")
        var cuniaCount = 0
        for item in itemsFromCheck4 {
            if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String {
                if planetOfOrigin == "Cunia" {
                    cuniaCount += 1
                } else {
                    print("ItemsFromPlanet FAILED: Your implementation of itemsFromPlanet does not handle cases when checking for items from a planet other than Glinda.")
                    return false
                }
            }
        }
        if cuniaCount != 5 {
            print("ItemsFromPlanet FAILED: Your implementation of itemsFromPlanet does not handle cases when checking for items from a planet other than Glinda.")
            return false
        }
        
        return true
    }
    
    // MARK: OldestItemFromPlanet
    
    func testOldestItemFromPlanet() -> Bool {
        
        // check 1
        if delegate.handleOldestItemFromPlanet([UDItem](), planet: "Cunia") != nil {
            print("OldestItemFromPlanet FAILED: If the inventory is empty, then nil should be returned.")
            return false
        }
        
        // check 2
        let item = delegate.handleOldestItemFromPlanet(delegate.inventory, planet: "Cunia")
        if item != UDItemIndex.items["Crystal"]! {
            print("OldestItemFromPlanet FAILED: The oldest item from Cunia was not returned.")
            return false
        }
        
        // check 3
        let item1 = UDItem(itemID: 0, itemType: .Weapon, name: "Test1", baseValue: 1, inscription: nil, rarity: .Common, historicalData: ["CarbonAge": 30, "PlanetOfOrigin": "TestPlanet"])
        let item2 = UDItem(itemID: 1, itemType: .Weapon, name: "Test2", baseValue: 2, inscription: nil, rarity: .Common, historicalData: ["PlanetOfOrigin": "TestPlanet"])
        let item3 = UDItem(itemID: 2, itemType: .Weapon, name: "Test3", baseValue: 3, inscription: nil, rarity: .Common, historicalData: ["CarbonAge": 1000, "PlanetOfOrigin": "TestPlanet"])
        let testItems = [item1, item2, item3]
        let checkItem = delegate.handleOldestItemFromPlanet(testItems, planet: "TestPlanet")
        if checkItem != testItems[2] {
            print("OldestItemFromPlanet FAILED: An item without a CarbonAge was not correctly skipped over.")
            return false
        }
        
        return true
    }
    
    // MARK: XORCipherKeySearch
    
    func testXORCipherKeySearch() -> Bool {
        
        // check 1
        let key1 = delegate.handleXORCipherKeySearch([UInt8]("yhmoexu".utf8))
        if key1 != 12 {
            print("XORCipherKeySearch FAILED: \(key1) is not the correct key used to decrypt the message \"yhmoexu\".")
            return false
        }
        
        // check 2
        let key2 = delegate.handleXORCipherKeySearch([UInt8]("0!$&,1<".utf8))
        if key2 != 69 {
            print("XORCipherKeySearch FAILED: \(key1) is not the correct key used to decrypt the message \"0!$&,1<\".")
            return false
        }
        
        return true
    }
    
    // MARK: RarityOfItems
    
    func testRarityOfItems() -> Bool {
        
        // check 1
        if delegate.handleRarityOfItems([UDItem]()) != [
            .Common: 0,
            .Uncommon: 0,
            .Rare: 0,
            .Legendary: 0
        ] {
            print("RarityOfItems FAILED: If the inventory is empty, then there should be 0 items returned for each rarity.")
            return false
        }
        
        // check 2
        let items2 = delegate.handleRarityOfItems(allItems())
        if items2[.Common] != 3 {
            print("RarityOfItems FAILED: An incorrect number of .Common items was returned.")
            return false
        }
        if items2[.Uncommon] != 3 {
            print("RarityOfItems FAILED: An incorrect number of .Uncommon items was returned.")
            return false
        }
        if items2[.Rare] != 2 {
            print("RarityOfItems FAILED: The incorrect number of .Rare items was returned.")
            return false
        }
        if items2[.Legendary] != 1 {
            print("RarityOfItems FAILED: The incorrect number of .Legendary items was returned.")
            return false
        }
        
        // check 3
        let items3 = delegate.handleRarityOfItems(delegate.inventory)
        if items3[.Common] != 2 {
            print("RarityOfItems FAILED: An incorrect number of .Common items was returned.")
            return false
        }
        if items3[.Uncommon] != 3 {
            print("RarityOfItems FAILED: An incorrect number of .Uncommon items was returned.")
            return false
        }
        if items3[.Rare] != 0 {
            print("RarityOfItems FAILED: The incorrect number of .Rare items was returned.")
            return false
        }
        if items3[.Legendary] != 1 {
            print("RarityOfItems FAILED: The incorrect number of .Legendary items was returned.")
            return false
        }
        
        return true
    }
    
    // MARK: ItemComparison
    
    func testItemComparison() -> Bool {
        
        // check 1
        var item1 = UDItemIndex.items["BeamRifle"]!
        var item2 = UDItemIndex.items["LaserBazooka"]!
        if !(item1 < item2) {
            print("ItemComparison FAILED: An .Uncommon item should be less than a .Rare item.")
            return false
        }
        
        // check 2
        item1 = UDItemIndex.items["LaserCannon"]!
        item2 = UDItemIndex.items["LaserBazooka"]!
        if !(item1 < item2) {
            print("ItemComparison FAILED: If two items have the same rarity, then their base value should be used to determine which item is less valuable.")
            return false
        }
        
        // check 3
        item1 = UDItemIndex.items["GlowSphere"]!
        item2 = UDItemIndex.items["GammaShard"]!
        if (item1 < item2) {
            print("ItemComparison FAILED: A .Legendary item should not be less than an .Uncommon item.")
            return false
        }
        
        return true
    }
    
    // MARK: BannedItems
    
    func testBannedItems() -> Bool {
        
        // check 1
        let bannedItemIDs = delegate.handleBannedItems("ItemList")
        
        if bannedItemIDs.count != 2 {
            print("BannedItems FAILED: An incorrect number of items were banned.")
            return false
        }
        
        for itemID in bannedItemIDs {
            if itemID != 4 && itemID != 0 {
                print("BannedItems FAILED: An item was banned that should not have been banned.")
                return false
            }
        }
        
        return true
    }
    
    // MARK: PlanetData
    
    func testPlanetData() -> Bool {
        
        // check 1
        let highestValuePlanet = delegate.handlePlanetData("PlanetData")
        if highestValuePlanet != "Strov" {
            print("PlanetData FAILED: \"\(highestValuePlanet)\" is not the most intriguing planet.")
            return false
        }
        
        return true
    }
    
    // MARK: MostCommonCharacter
    
    func testMostCommonCharacter() -> Bool {
        
        // check 1
        if delegate.handleMostCommonCharacter([UDItem]()) != nil {
            print("MostCommonCharacter FAILED: If the inventory is empty, then nil should be returned.")
            return false
        }
        
        // check 2
        let itemsWithOutMoonOrBazooka = allItems().filter({!$0.name.lowercaseString.containsString("moon") && !$0.name.lowercaseString.containsString("bazooka")})
        
        if delegate.handleMostCommonCharacter(itemsWithOutMoonOrBazooka) != "a" {
            print("MostCommonCharacter FAILED: The most common character was not returned.")
            return false
        }
        
        // check 3
        if delegate.handleMostCommonCharacter(delegate.inventory) != "o" {
            print("MostCommonCharacter FAILED: The most common character was not returned.")
            return false
        }
        
        return true
    }
}

// MARK: - RequestTester (Alien Adventure 2 Process Requests)

extension UDRequestTester {
    
    // MARK: ItemsFromPlanet
    
    func processItemsFromPlanet(failed: Bool) -> String {
        
        let itemsFromGlinda = delegate.handleItemsFromPlanet(delegate.inventory, planet: "Glinda")
        let processingString = "Hero: [Hands over \(itemsFromGlinda.count) items]"
        
        if(!failed) {
            delegate.inventory = delegate.inventory.filter({
                if let planetOfOrigin = $0.historicalData["PlanetOfOrigin"] as? String where planetOfOrigin != "Glinda" {
                    return true
                } else {
                    return false
                }
            })
        }
        
        return processingString
    }
    
    // MARK: OldestItemFromPlanet
    
    func processOldestItemFromPlanet() -> String {
        
        var processingString = "Hero: [Shows the Alien "
        if let oldestItem = delegate.handleOldestItemFromPlanet(delegate.inventory, planet: "Cunia") {
            processingString += "the \(oldestItem.name.lowercaseString)]"
        } else {
            processingString += "NOTHING!]"
        }
        
        return processingString
    }
    
    // MARK: XORCipherKeySearch
    
    func processXORCipherKeySearch() -> String {
        
        var processingString = "Hero: \"That's easy. The key is "
        
        let key = delegate.handleXORCipherKeySearch([UInt8]("yhmoexu".utf8))
        
        processingString += "\(key)!\""
        
        return processingString
    }
    
    // MARK: RarityOfItems
    
    func processRarityOfItems() -> String {
        
        var processingString = "Hero: \""
        
        if delegate.handleRarityOfItems(delegate.inventory) == [
            .Common: 2,
            .Uncommon: 3,
            .Rare: 0,
            .Legendary: 1
            ] {
                processingString += "Why don't you try this approach?\""
        } else {
            processingString += "Umm... actually I'm not really sure...\""
        }
        
        return processingString
    }
    
    // MARK: ItemComparison
    
    func processItemComparison() -> String {
        
        return "Hero: \"Just try comparing items like this...\""
    }
    
    // MARK: BannedItems
    
    func processBannedItems() -> String {
        
        var processingString = "Hero: \""
        let bannedItemIDs = delegate.handleBannedItems("ItemList")
        
        if bannedItemIDs.count == 0 {
            processingString += "There is nothing on this list that should be banned.\""
        } else if bannedItemIDs.count == 1 {
            processingString += "This item here... it should be banned.\""
        } else {
            processingString += "These \(bannedItemIDs.count) items on the list should be banned.\""
        }
        
        return processingString
    }
    
    // MARK: PlanetData
    
    func processPlanetData() -> String {
        
        let targetPlanet = delegate.handlePlanetData("PlanetData")
        
        if targetPlanet == "" {
            return "Hero: \"Actually, all the planets on this list look pretty good.\""
        } else {
            return "Hero: \"That's easy. You should definately check out the planet \"\(targetPlanet)\"!\""
        }
    }
    
    // MARK: MostCommonCharacter
    
    func processMostCommonCharacter() -> String {
        
        var processingString = "Hero: \""
        
        if let commonCharacter = delegate.handleMostCommonCharacter(delegate.inventory) {
            processingString += "The most common character is \"\(commonCharacter)\"\"."
        } else {
            processingString += "I can't really tell. I don't know which character is the most common...\""
        }
        
        return processingString
    }
}