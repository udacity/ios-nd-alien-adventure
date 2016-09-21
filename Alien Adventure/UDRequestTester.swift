//
//  UDRequestTester.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/29/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

// MARK: - UDRequestTester

class UDRequestTester {
    
    // MARK: Properties
    
    var delegate: UDRequestDelegate

    // MARK: Initializer
    
    init(delegate: UDRequestDelegate) {
        self.delegate = delegate
    }
    
    // MARK: Run Test
    
    func runTestForRequestType(_ requestType: UDRequestType) -> Bool {
        switch(requestType) {
        // Alien Adventure 1
        case .reverseLongestName:
            return testReverseLongestName()
        case .matchMoonRocks:
            return testMatchMoonRocks()
        case .inscriptionEternalStar:
            return testInscriptionEternalStar()
        case .leastValuableItem:
            return testLeastValuableItem()
        case .shuffleStrings:
            return testShuffleStrings()
        // Alien Adventure 2
        case .itemsFromPlanet:
            return testItemsFromPlanet()
        case .oldestItemFromPlanet:
            return testOldestItemFromPlanet()
        case .xorCipherKeySearch:
            return testXORCipherKeySearch()
        case .rarityOfItems:
            return testRarityOfItems()
        case .itemComparison:
            return testItemComparison()
        case .bannedItems:
            return testBannedItems()
        case .planetData:
            return testPlanetData()
        case .mostCommonCharacter:
            return testMostCommonCharacter()
        // Alien Adventure 3
        case .basicCheck:
            return testBasicCheck()
        case .advancedCheck:
            return testAdvancedCheck()
        case .expertCheck:
            return testExpertCheck()
        case .checkBadges:
            return testCheckBadges()
        // Alien Adventure 4
        case .policingItems:
            return testPolicingItems()
        case .findTheLasers:
            return testFindTheLasers()
        case .redefinePolicingItems:
            return testRedefinePolicingItems()
        case .boostItemValue:
            return testBoostItemValue()
        case .sortLeastToGreatest:
            return testSortLeastToGreatest()
        case .getCommonItems:
            return testGetCommonItems()
        case .totalBaseValue:
            return testTotalBaseValue()
        case .removeDuplicates:
            return testRemoveDuplicates()            
        // Undefined
        case .undefined:
            return false
        }
    }
    
    func processRequestType(_ requestType: UDRequestType, failed: Bool) -> String {
        switch(requestType) {
        // Alien Adventure 1
        case .reverseLongestName:
            return processReverseLongestName(failed)
        case .matchMoonRocks:
            return processMatchMoonRocks(failed)
        case .inscriptionEternalStar:
            return processInscriptionEternalStar(failed)
        case .leastValuableItem:
            return processLeastValuableItem(failed)
        case .shuffleStrings:
            return processShuffleStrings(failed)
        // Alien Adventure 2
        case .itemsFromPlanet:
            return processItemsFromPlanet(failed)
        case .oldestItemFromPlanet:
            return processOldestItemFromPlanet()
        case .xorCipherKeySearch:
            return processXORCipherKeySearch()
        case .rarityOfItems:
            return processRarityOfItems()
        case .itemComparison:
            return processItemComparison()
        case .bannedItems:
            return processBannedItems()
        case .planetData:
            return processPlanetData()
        case .mostCommonCharacter:
            return processMostCommonCharacter()
        // Alien Adventure 3
        case .basicCheck:
            return processBasicCheck()
        case .advancedCheck:
            return processAdvancedCheck()
        case .expertCheck:
            return processExpertCheck()
        case .checkBadges:
            return processCheckBadges(failed)
            // Alien Adventure 4
        case .policingItems:
            return processPolicingItems()
        case .findTheLasers:
            return processFindTheLasers()
        case .redefinePolicingItems:
            return processRedefinePolicingItems()
        case .boostItemValue:
            return processBoostItemValue()
        case .sortLeastToGreatest:
            return processSortLeastToGreatest()
        case .getCommonItems:
            return processGetCommonItems()
        case .totalBaseValue:
            return processTotalBaseValue()
        case .removeDuplicates:
            return processRemoveDuplicates()
        // Undefined
        case .undefined:
            return ""
        }
    }
    
    // MARK: Helpers
    
    func allItems() -> [UDItem] {
        var items = [UDItem]()
        for item in UDItemIndex.items {
            items.append(item.1)
        }
        return items
    }
}
