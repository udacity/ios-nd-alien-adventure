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
    case ReverseLongestName = "ReverseLongestName"
    case MatchMoonRocks = "MatchMoonRocks"
    case InscriptionEternalStar = "InscriptionEternalStar"
    case LeastValuableItem = "LeastValuableItem"
    case ShuffleStrings = "ShuffleStrings"
    
    // Alien Adventure 2
    case ItemsFromPlanet = "ItemsFromPlanet"
    case OldestItemFromPlanet = "OldestItemFromPlanet"
    case XORCipherKeySearch = "XORCipherKeySearch"
    case RarityOfItems = "RarityOfItems"
    case ItemComparison = "ItemComparison"
    case BannedItems = "BannedItems"
    case PlanetData = "PlanetData"
    case MostCommonCharacter = "MostCommonCharacter"
    
    case Undefined = "Undefined"
}

// MARK: - UDRequestDelegate

protocol UDRequestDelegate {
    var inventory: [UDItem] {get set}
    // Alien Adventure 1
    func handleReverseLongestName(inventory: [UDItem]) -> String
    func handleMatchMoonRocks(inventory: [UDItem]) -> [UDItem]
    func handleInscriptionEternalStar(inventory: [UDItem]) -> UDItem?
    func handleLeastValuableItem(inventory: [UDItem]) -> UDItem?
    func handleShuffleStrings(s1 s1: String, s2: String, shuffle: String) -> Bool
    // Alien Adventure 2
    func handleItemsFromPlanet(inventory: [UDItem], planet: String) -> [UDItem]
    func handleOldestItemFromPlanet(inventory: [UDItem], planet: String) -> UDItem?
    func handleXORCipherKeySearch(encryptedString: [UInt8]) -> UInt8
    func handleRarityOfItems(inventory: [UDItem]) -> [UDItemRarity:Int]
    func handleItemComparison(item1 item1: UDItem, item2: UDItem) -> Bool
    func handleBannedItems(dataFile: String) -> [Int]
    func handlePlanetData(dataFile: String) -> String
    func handleMostCommonCharacter(inventory: [UDItem]) -> Character?
}

// MARK: - UDRequest

struct UDRequest {
    
    // MARK: Properties
    
    var requestType: UDRequestType
    var initialConversation: UDConversation
    var passConversation: UDConversation
    var failConversation: UDConversation
    
    // MARK: Constructor
    
    static func UDRequestWithoutPassFail(initialDialogue: [UDLineOfDialogue]) -> UDRequest {
        return UDRequest(requestType: .Undefined, initialConversation: UDConversation(linesOfDialogue: initialDialogue), passConversation: UDConversation(), failConversation: UDConversation())
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