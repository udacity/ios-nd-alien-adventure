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
        if delegate.handleReverseLongestName([UDItem]()) != "" { return false }
        
        // check 2
        if delegate.handleReverseLongestName(allItems()) != "akoozaBresaL" { return false }
        
        // check 3
        if delegate.handleReverseLongestName(delegate.inventory) != "nonnaCresaL" { return false }
        
        return true
    }
    
    // MARK: MatchMoonRocks
    
    func testMatchMoonRocks() -> Bool {
        
        // check 1
        let itemsFromCheck1 = delegate.handleMatchMoonRocks([UDItem]())
        if itemsFromCheck1.count != 0 {
            return false
        }
        
        // check 2
        let itemsFromCheck2 = delegate.handleMatchMoonRocks(allItems())
        var moonRocksCount2 = 0
        for item in itemsFromCheck2 {
            if item == UDItemIndex.items["MoonRock"]! {
                moonRocksCount2++
            }
        }
        if moonRocksCount2 != 1 {
            return false
        }
        
        // check 3
        let itemsFromCheck3 = delegate.handleMatchMoonRocks(delegate.inventory)
        var moonRocksCount3 = 0
        for item in itemsFromCheck3 {
            if item == UDItemIndex.items["MoonRock"]! {
                moonRocksCount3++
            }
        }
        if moonRocksCount3 != 2 {
            return false
        }
        
        return true
    }
    
    // MARK: InscriptionEternalStar
    
    func testInscriptionEternalStar() -> Bool {
        
        // check 1
        if delegate.handleInscriptionEternalStar([UDItem]()) != nil {
            return false
        }
        
        // check 2
        if let item = delegate.handleInscriptionEternalStar(delegate.inventory) where item == UDItemIndex.items["GlowSphere"]! {
            // do nothing, this is what should be returned
        } else {
            return false
        }
        
        return true
    }
    
    // MARK: LeastValuableItem
    
    func testLeastValuableItem() -> Bool {
        
        // check 1
        if delegate.handleLeastValuableItem([UDItem]()) != nil {
            return false
        }
        
        // check 2
        if let result = delegate.handleLeastValuableItem(allItems()) where result != UDItemIndex.items["Dust"]! {
            return false
        }
        
        // check 3
        if let result = delegate.handleLeastValuableItem(delegate.inventory) where result != UDItemIndex.items["MoonRubble"]! {
            return false
        }
        
        return true
    }
    
    // MARK: ShuffleStrings
    
    func testShuffleStrings() -> Bool {
        
        // check 1
        if !delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "acbd") {
            return false
        }
        
        // check 2
        if delegate.handleShuffleStrings(s1: "ab", s2: "cd", shuffle: "badc") {
            return false
        }
        
        // check 3
        if !delegate.handleShuffleStrings(s1: "", s2: "", shuffle: "") {
            return false
        }
        
        // check 4
        if delegate.handleShuffleStrings(s1: "", s2: "", shuffle: "sdf") {
            return false
        }
        
        return true
    }
}

// MARK: - RequestTester (Alien Adventure 1 Process Requests)

extension UDRequestTester {
    
    // MARK: ReverseLongString
    
    func processReverseLongestName() -> String {
        
        let reverseLongestName = delegate.handleReverseLongestName(delegate.inventory)
        
        return "Hero: \"How about \(reverseLongestName)?\""
    }
    
    // MARK: MatchMoonRocks
    
    func processMatchMoonRocks(failed: Bool) -> String {
        
        var processingString = "Hero: [Hands over "
        let moonRocks = delegate.handleMatchMoonRocks(delegate.inventory)
        
        if moonRocks.count == 0 {
            processingString += "NOTHING!]"
        } else {
            processingString += "\(moonRocks.count) MoonRocks]"
        }
        
        if(!failed) {
            delegate.inventory = delegate.inventory.filter({$0.name != "MoonRock"})
        }
        
        return processingString
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
    
    func processShuffleStrings() -> String {
        
        var processingString = "Hero: \"So is (\"abc\", \"def\", \"adbecf\") a valid shuffle? Let's see... "
        
        processingString += (delegate.handleShuffleStrings(s1: "abc", s2: "def", shuffle: "adbecf")) ? "yes it is!\"" : "maybe? I'm not sure!\""
        
        return processingString
    }
}