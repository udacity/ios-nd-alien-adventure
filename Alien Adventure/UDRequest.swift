//
//  UDRequest.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/28/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDRequestType

enum UDRequestType: String {
    
    // Alien Adventure 1
    case reverseLongestName = "ReverseLongestName"
    case matchMoonRocks = "MatchMoonRocks"
    case inscriptionEternalStar = "InscriptionEternalStar"
    case leastValuableItem = "LeastValuableItem"
    case shuffleStrings = "ShuffleStrings"
    
    // Alien Adventure 2
    case itemsFromPlanet = "ItemsFromPlanet"
    case oldestItemFromPlanet = "OldestItemFromPlanet"
    case xorCipherKeySearch = "XORCipherKeySearch"
    case rarityOfItems = "RarityOfItems"
    case itemComparison = "ItemComparison"
    case bannedItems = "BannedItems"
    case planetData = "PlanetData"
    case mostCommonCharacter = "MostCommonCharacter"
    
    // Alien Adventure 3
    case basicCheck = "BasicCheck"
    case advancedCheck = "AdvancedCheck"
    case expertCheck = "ExpertCheck"
    case checkBadges = "CheckBadges"
    
    // Alien Adventure 4
    case policingItems = "PolicingItems"
    case findTheLasers = "FindTheLasers"
    case redefinePolicingItems = "RedefinePolicingItems"
    case boostItemValue = "BoostItemValue"
    case sortLeastToGreatest = "SortLeastToGreatest"
    case getCommonItems = "GetCommonItems"
    case totalBaseValue = "TotalBaseValue"
    case removeDuplicates = "RemoveDuplicates"
    
    case undefined = "Undefined"
}

// MARK: - UDRequestDelegate

protocol UDRequestDelegate {
    var inventory: [UDItem] {get set}
    var badgeManager: BadgeManager? {get set}
    // Alien Adventure 1
    func handleReverseLongestName(_ inventory: [UDItem]) -> String
    func handleMatchMoonRocks(_ inventory: [UDItem]) -> [UDItem]
    func handleInscriptionEternalStar(_ inventory: [UDItem]) -> UDItem?
    func handleLeastValuableItem(_ inventory: [UDItem]) -> UDItem?
    func handleShuffleStrings(_ s1: String, s2: String, shuffle: String) -> Bool
    // Alien Adventure 2
    func handleItemsFromPlanet(_ inventory: [UDItem], planet: String) -> [UDItem]
    func handleOldestItemFromPlanet(_ inventory: [UDItem], planet: String) -> UDItem?
    func handleXORCipherKeySearch(_ encryptedString: [UInt8]) -> UInt8
    func handleRarityOfItems(_ inventory: [UDItem]) -> [UDItemRarity:Int]
    func handleItemComparison(_ item1: UDItem, item2: UDItem) -> Bool
    func handleBannedItems(_ dataFile: String) -> [Int]
    func handlePlanetData(_ dataFile: String) -> String
    func handleMostCommonCharacter(_ inventory: [UDItem]) -> Character?
    // Alien Adventure 3
    func handleBasicCheck() -> Bool
    func handleAdvancedCheck() -> Bool
    func handleExpertCheck() -> Bool
    func handleCheckBadges(_ badges: [Badge], requestTypes: [UDRequestType]) -> Bool
    // Alien Adventure 4
    func handlePolicingItems(_ inventory: [UDItem], policingFilter: (UDItem) throws -> Void) -> [UDPolicingError:Int]
    func handleFindTheLasers() -> ((UDItem) -> Bool)
    func handleRedefinePolicingItems() -> ((UDItem) throws -> Void)
    func handleBoostItemValue(_ inventory: [UDItem]) -> [UDItem]
    func handleSortLeastToGreatest(_ inventory: [UDItem]) -> [UDItem]
    func handleGetCommonItems(_ inventory: [UDItem]) -> [UDItem]
    func handleTotalBaseValue(_ inventory: [UDItem]) -> Int
    func handleRemoveDuplicates(_ inventory: [UDItem]) -> [UDItem]
}

// MARK: - UDRequest

struct UDRequest {
    
    // MARK: Properties
    
    var requestType: UDRequestType
    var initialConversation: UDConversation
    var passConversation: UDConversation
    var failConversation: UDConversation
    
    // MARK: Constructor
    
    static func UDRequestWithoutPassFail(_ initialDialogue: [UDLineOfDialogue]) -> UDRequest {
        return UDRequest(requestType: .undefined, initialConversation: UDConversation(linesOfDialogue: initialDialogue), passConversation: UDConversation(), failConversation: UDConversation())
    }
}

// MARK: - UDRequest: CustomStringConvertible

extension UDRequest: CustomStringConvertible {
    var description : String {
        var result = ""
        result += "Request Type:\n\(requestType)\n"
        result += "Initial Conversation:\n\(initialConversation)"
        result += "Pass Conversation:\n\(passConversation)"
        result += "Fail Conversation:\n\(failConversation)"
        return result
    }
}
