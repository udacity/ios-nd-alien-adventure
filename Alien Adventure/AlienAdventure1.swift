//
//  AlienAdventure1.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - RequestTester (Alien Adventure 1 Tests)

extension UDRequestTester {
    
    // MARK: ReverseLongString
    
    func testReverseLongestName() -> Bool {
        
        // check 1
        if delegate.handleReverseLongestName([UDItem]()) != "" {
            print("ReverseLongestName FAILED: If the inventory is empty, then the method should return \"\".")
            return false
        }
        
        // check 2
        if delegate.handleReverseLongestName(allItems()) != "akoozaBresaL" {
            print("ReverseLongestName FAILED: The reverse longest string was not returned.")
            return false
        }
        
        // check 3
        if delegate.handleReverseLongestName(delegate.inventory) != "nonnaCresaL" {
            print("ReverseLongestName FAILED: The reverse longest string was not returned.")
            return false
        }
        
        return true
    }
    
    // MARK: MatchMoonRocks
    
    func testMatchMoonRocks() -> Bool {
        
        // check 1
        let itemsFromCheck1 = delegate.handleMatchMoonRocks([UDItem]())
        if itemsFromCheck1.count != 0 {
            print("MatchMoonRocks FAILED: If the inventory is empty, then no MoonRocks should be returned.")
            return false
        }
        
        // check 2
        let itemsFromCheck2 = delegate.handleMatchMoonRocks(allItems())
        var moonRocksCount2 = 0
        for item in itemsFromCheck2 {
            if item == UDItemIndex.items["MoonRock"]! {
                moonRocksCount2 += 1
            }
        }
        if moonRocksCount2 != 1 {
            print("MatchMoonRocks FAILED: An incorrect number of MoonRocks was returned.")
            return false
        }
        
        // check 3
        let itemsFromCheck3 = delegate.handleMatchMoonRocks(delegate.inventory)
        var moonRocksCount3 = 0
        for item in itemsFromCheck3 {
            if item == UDItemIndex.items["MoonRock"]! {
                moonRocksCount3 += 1
            }
        }
        if moonRocksCount3 != 2 || itemsFromCheck3.count != 2 {
            print("MatchMoonRocks FAILED: An incorrect number of MoonRocks was returned.")
            return false
        }
        
        return true
    }
    
    // MARK: InscriptionEternalStar
    
    func testInscriptionEternalStar() -> Bool {
        
        // check 1
        if delegate.handleInscriptionEternalStar([UDItem]()) != nil {
            print("InscriptionEternalStar FAILED: If the inventory is empty, then nil should be returned.")
            return false
        }
        
        // check 2
        let item = delegate.handleInscriptionEternalStar(delegate.inventory)
        if item != UDItemIndex.items["GlowSphere"]! {
            print("InscriptionEternalStar FAILED: The correct item was not returned.")
            return false
        }
        
        return true
    }
    
    // MARK: LeastValuableItem
    
    func testLeastValuableItem() -> Bool {
        
        // check 1
        if delegate.handleLeastValuableItem([UDItem]()) != nil {
            print("LeastValuableItem FAILED: If the inventory is empty, then nil should be returned.")
            return false
        }
        
        // check 2
        let result2 = delegate.handleLeastValuableItem(allItems())
        if result2 != UDItemIndex.items["Dust"]! {
            print("LeastValuableItem FAILED: The least valuable item was not returned.")
            return false
        }
        
        // check 3
        let result3 = delegate.handleLeastValuableItem(delegate.inventory)
        if result3 != UDItemIndex.items["MoonRubble"]! {
            print("LeastValuableItem FAILED: The least valuable item was not returned.")
            return false
        }
        
        return true
    }
    
    // MARK: ShuffleStrings
    
    func testShuffleStrings() -> Bool {
        
        // check 1
        if !delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "acbd") {
            print("ShuffleStrings FAILED: The shuffle for the input (\"ab\", \"cd\", \"acbd\") is valid, but false was returned.")
            return false
        }
        
        // check 2
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "badc") {
            print("ShuffleStrings FAILED: The shuffle for the input (\"ab\", \"cd\", \"badc\") is invalid, but true was returned.")
            return false
        }
        
        // check 3
        if !delegate.handleShuffleStrings(s1: "", s2: "", shuffle: "") {
            print("ShuffleStrings FAILED: The shuffle for the input (\"\", \"\", \"\") is valid, but false was returned.")
            return false
        }
        
        // check 4
        if delegate.handleShuffleStrings(s1: "", s2: "", shuffle: "sdf") {
            print("ShuffleStrings FAILED: The shuffle for the input (\"\", \"\", \"sdf\") is invalid, but true was returned.")
            return false
        }
        
        // check 5
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "abef") {
            print("ShuffleStrings FAILED: The shuffle for the input (\"ab\", \"cd\", \"abef\") is invalid, but true was returned.")
            return false
        }
        
        // check 6
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "abdc") {
            print("ShuffleStrings FAILED: The shuffle for the input (\"ab\", \"cd\", \"abdc\") is invalid, but true was returned.")
            return false
        }
        
        return true
    }
}

// MARK: - RequestTester (Alien Adventure 1 Process Requests)

extension UDRequestTester {
    
    // MARK: ReverseLongString
    
    func processReverseLongestName(failed: Bool) -> String {
        
        if !failed {
            let reverseLongestName = delegate.handleReverseLongestName(delegate.inventory)
            
            return "Hero: \"How about \(reverseLongestName)?\""
        } else {
            return "Hero: \"Uhh... Udacity?\""
        }
    }
    
    // MARK: MatchMoonRocks
    
    func processMatchMoonRocks(failed: Bool) -> String {
        
        if(!failed) {
            let moonRocks = delegate.handleMatchMoonRocks(delegate.inventory)
            delegate.inventory = delegate.inventory.filter({$0.name != "MoonRock"})
            return "Hero: [Hands over \(moonRocks.count) MoonRocks]"
        } else {
            return "Hero: [Hands over some items (they might be MoonRocks...)]"
        }
    }
    
    // MARK: InscriptionEternalStar
    
    func processInscriptionEternalStar(failed: Bool) -> String {
        
        var processingString = "Hero: [Hands over "
        if let eternalStarItem = delegate.handleInscriptionEternalStar(delegate.inventory) {
            processingString += "the \(eternalStarItem.name)]"
            if(!failed) {
                delegate.inventory = delegate.inventory.filter({$0.inscription == nil || $0 != eternalStarItem})
            }
        } else {
            processingString += "NOTHING!]"
        }
        
        return processingString
    }
    
    // MARK: LeastValuableItem
    
    func processLeastValuableItem(failed: Bool) -> String {
        
        var processingString = "Hero: [Hands over "
        if let leastValuableItem = delegate.handleLeastValuableItem(delegate.inventory) {
            processingString += "the \(leastValuableItem.name)]"
            if(!failed) {
                for (idx, item) in delegate.inventory.enumerate() {
                    if item == leastValuableItem {
                        delegate.inventory.removeAtIndex(idx)
                        break
                    }
                }
            }
        } else {
            processingString += "NOTHING!]"
        }
        
        return processingString
    }
    
    // MARK: ShuffleStrings
    
    func processShuffleStrings(failed: Bool) -> String {
        
        // check 1
        if !delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "acbd") {
            return "Hero: \"So is (\"ab\", \"cd\", \"acbd\") a valid shuffle? Umm... no?\""
        }
        
        // check 2
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "badc") {
            return "Hero: \"So is (\"ab\", \"cd\", \"badc\") a valid shuffle? Umm... yes?\""
        }
        
        // check 3
        if !delegate.handleShuffleStrings(s1: "", s2: "", shuffle: "") {
            return "Hero: \"So is (\"\", \"\", \"\") a valid shuffle? Umm... no?\""
        }
        
        // check 4
        if delegate.handleShuffleStrings(s1: "", s2: "", shuffle: "sdf") {
            return "Hero: \"So is (\"\", \"\", \"sdf\") a valid shuffle? Umm... yes?\""
        }
        
        // check 5
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "abef") {
            return "Hero: \"So is (\"ab\", \"cd\", \"abef\") a valid shuffle? Umm... yes?\""
        }
        
        // check 6
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "abdc") {
            return "Hero: \"So is (\"ab\", \"cd\", \"abdc\") a valid shuffle? Umm... yes?\""
        }
        
        return "Hero: \"So is (\"ab\", \"cd\", \"badc\") a valid shuffle? No it isn't!\""
    }
}