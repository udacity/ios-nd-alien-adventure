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
            return false
        }
        
        // check 2
        let itemsFromCheck2 = delegate.handleItemsFromPlanet(allItems(), planet: "Glinda")
        var glindaCount2 = 0
        for item in itemsFromCheck2 {
            if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String {
                if planetOfOrigin == "Glinda" {
                    glindaCount2++
                } else {
                    return false
                }
            }
        }
        if glindaCount2 != 3 {
            return false
        }
        
        // check 3
        let itemsFromCheck3 = delegate.handleItemsFromPlanet(delegate.inventory, planet: "Glinda")
        var glindaCount3 = 0
        for item in itemsFromCheck3 {
            if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String {
                if planetOfOrigin == "Glinda" {
                    glindaCount3++
                } else {
                    return false
                }
            }
        }
        if glindaCount3 != 4 {
            return false
        }
        
        return true
    }
    
    // MARK: OldestItemFromPlanet
    
    func testOldestItemFromPlanet() -> Bool {
        
        // check 1
        if delegate.handleOldestItemFromPlanet([UDItem](), planet: "Cunia") != nil {
            return false
        }
        
        // check 2
        if let item = delegate.handleOldestItemFromPlanet(delegate.inventory, planet: "Cunia") where item == UDItemIndex.items["Crystal"]! {
            // do nothing, this is what should be returned
        } else {
            return false
        }
        
        return true
    }
    
    // MARK: XORCipherKeySearch
    
    func testXORCipherKeySearch() -> Bool {

        // check 1
        if delegate.handleXORCipherKeySearch([UInt8]("yhmoexu".utf8)) != 12 {
            return false
        }
        
        // check 2
        if delegate.handleXORCipherKeySearch([UInt8]("0!$&,1<".utf8)) != 69 {
            return false
        }
        
        return true
    }
    
    // MARK: RarityOfItems
    
    func testRarityOfItems() -> Bool {
        
        // check 1
        if delegate.handleRarityOfItems([UDItem]()) != [UDItemRarity:Int]() {
            return false
        }
        
        // check 2
        if delegate.handleRarityOfItems(allItems()) != [
            .Common: 3,
            .Uncommon: 3,
            .Rare: 2,
            .Legendary: 1
            ] { return false }

        // check 3
        if delegate.handleRarityOfItems(delegate.inventory) != [
            .Common: 2,
            .Uncommon: 3,
            .Legendary: 1
            ] { return false }
        
        return true
    }
    
    // MARK: ItemComparison
    
    func testItemComparison() -> Bool {
        
        // check 1
        if !(UDItemIndex.items["BeamRifle"]! < UDItemIndex.items["LaserBazooka"]!) {
            return false
        }
        
        // check 2
        if !(UDItemIndex.items["LaserCannon"]! < UDItemIndex.items["LaserBazooka"]!) {
            return false
        }
        
        // check 3
        if !(UDItemIndex.items["LightShard"]! < UDItemIndex.items["GlowSphere"]!) {
            return false
        }
        
        return true
    }
    
    // MARK: BannedItems
    
    func testBannedItems() -> Bool {
        
        // check 1
        let bannedItemIDs = delegate.handleBannedItems("ItemList")
        
        if bannedItemIDs.count != 2 {
            return false
        }
        
        for itemID in bannedItemIDs {
            if itemID != 4 && itemID != 0 {
                return false
            }
        }
        
        return true
    }
    
    // MARK: PlanetData
    
    func testPlanetData() -> Bool {
        
        // check 1
        if delegate.handlePlanetData("PlanetData") != "Strov" {
            return false
        }
        
        return true
    }
    
    // MARK: MostCommonCharacter
    
    func testMostCommonCharacter() -> Bool {
        
        // check 1
        if delegate.handleMostCommonCharacter([UDItem]()) != nil {
            return false
        }
        
        // check 2
        let itemsWithOutMoonOrBazooka = allItems().filter({!$0.name.lowercaseString.containsString("moon") && !$0.name.lowercaseString.containsString("bazooka")})
        
        if delegate.handleMostCommonCharacter(itemsWithOutMoonOrBazooka) != "e" {
            return false
        }
        
        // check 3
        if delegate.handleMostCommonCharacter(delegate.inventory) != "o" {
            return false
        }
        
        return true
    }
}

// MARK: - RequestTester (Alien Adventure 2 Process Requests)

extension UDRequestTester {
    
    // MARK: ItemsFromPlanet
    
    func processItemsFromPlanet(failed: Bool) -> String {
        
        var processingString = "Hero: [Hands over "
        let itemsFromGlinda = delegate.handleItemsFromPlanet(delegate.inventory, planet: "Glinda")
        
        if itemsFromGlinda.count == 0 {
            processingString += "NOTHING!]"
        } else {
            processingString += "\(itemsFromGlinda.count) items]"
        }
        
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
        
        var processingString = "Hero: That's easy. The key is "
        
        let key = delegate.handleXORCipherKeySearch([UInt8]("yhmoexu".utf8))
        
        processingString += "\(key)!"
        
        return processingString
    }
    
    // MARK: RarityOfItems
    
    func processRarityOfItems() -> String {
        
        var processingString = "Hero: "
                
        if delegate.handleRarityOfItems(delegate.inventory) == [
            .Common: 2,
            .Uncommon: 3,
            .Legendary: 1
            ] {
                processingString += "Why don't you try this approach?"
        } else {
            processingString += "Umm... actually I'm not really sure..."
        }
        
        return processingString
    }
    
    // MARK: ItemComparison
    
    func processItemComparison() -> String {

        return "Hero: Just try comparing items like this..."
    }
    
    // MARK: BannedItems
    
    func processBannedItems() -> String {

        var processingString = "Hero: "
        let bannedItemIDs = delegate.handleBannedItems("ItemList")
        
        if bannedItemIDs.count == 0 {
            processingString += "There is NOTHING on this list that should be banned."
        } else if bannedItemIDs.count == 1 {
            processingString += "This item here... it should be banned."
        } else {
            processingString += "These \(bannedItemIDs.count) items on the list should be banned."
        }
    
        return processingString
    }
    
    // MARK: PlanetData
    
    func processPlanetData() -> String {
        
        let targetPlanet = delegate.handlePlanetData("PlanetData")
        
        return "Hero: That's easy. You should definately check out the planet \(targetPlanet)!"
    }
    
    // MARK: MostCommonCharacter
    
    func processMostCommonCharacter() -> String {
        
        var processingString = "Hero: "
        
        if let commonCharacter = delegate.handleMostCommonCharacter(delegate.inventory) {
            processingString += "The most common character is \"\(commonCharacter)\"."
        } else {
            processingString += "I can't really tell. I don't know which character is the most common..."
        }
        
        return processingString
    }
}