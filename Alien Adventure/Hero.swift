//
//  Hero.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/16/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - Hero: SKSpriteNode

class Hero: SKSpriteNode {
    
    // MARK: Properties
    
    var inventory = [UDItem]()
    var badgeManager: BadgeManager? = nil
    
    // MARK: Initializers
    
    init(name: String, position: CGPoint, items: [UDItem]) {
        super.init(texture: UDAnimation.baseFrameForSprite[.Hero], color: UIColor.clearColor(), size: CGSize(width: 225, height: 175))
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 225, height: 175))
        if let heroPhysicsBody = self.physicsBody {
            UDCollision.setCollisionForPhysicsBody(heroPhysicsBody, belongsToMask: .Player, contactWithMask: .World, dynamic: true)
        }
        
        self.name = name
        self.position = position
        self.inventory = items
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Handling Requests Not Seen By Students
    
    func checkItemComparison(item1 item1: UDItem, item2: UDItem) -> Bool {
        return item1 < item2
    }

    // Adding Badges
    
    func addBadge(badge: Badge) {
        if let badgeManager = badgeManager {
            badgeManager.addBadge(badge)
        }
    }
}

extension Hero: UDRequestDelegate {
    
    // Alien Adventure 1
    
    func handleReverseLongestName(inventory: [UDItem]) -> String {
        return reverseLongestName(inventory)
    }
    
    func handleMatchMoonRocks(inventory: [UDItem]) -> [UDItem] {
        return matchMoonRocks(inventory)
    }
    
    func handleInscriptionEternalStar(inventory: [UDItem]) -> UDItem? {
        return inscriptionEternalStar(inventory)
    }
    
    func handleLeastValuableItem(inventory: [UDItem]) -> UDItem? {
        return leastValuableItem(inventory)
    }
    
    func handleShuffleStrings(s1 s1: String, s2: String, shuffle: String) -> Bool {
        return shuffleStrings(s1: s1, s2: s2, shuffle: shuffle)
    }
    
    // Alien Adventure 2
    
    func handleItemsFromPlanet(inventory: [UDItem], planet: String) -> [UDItem] {
        return itemsFromPlanet(inventory, planet: planet)
    }
    
    func handleOldestItemFromPlanet(inventory: [UDItem], planet: String) -> UDItem? {
        return oldestItemFromPlanet(inventory, planet: planet)
    }
    
    func handleXORCipherKeySearch(encryptedString: [UInt8]) -> UInt8 {
        return xorCipherKeySearch(encryptedString)
    }
    
    func handleRarityOfItems(inventory: [UDItem]) -> [UDItemRarity:Int] {
        return rarityOfItems(inventory)
    }
    
    func handleItemComparison(item1 item1: UDItem, item2: UDItem) -> Bool {
        return checkItemComparison(item1: item1, item2: item2)
    }
    
    func handleBannedItems(dataFile: String) -> [Int] {
        return bannedItems(dataFile)
    }
    
    func handlePlanetData(dataFile: String) -> String {
        return planetData(dataFile)
    }
    
    func handleMostCommonCharacter(inventory: [UDItem]) -> Character? {
        return mostCommonCharacter(inventory)
    }
    
    // Alien Adventure 3
    
    func handleBasicCheck() -> Bool {
        return true
    }
    
    func handleAdvancedCheck() -> Bool {
        return true
    }
    
    func handleExpertCheck() -> Bool {
        return true
    }
    
    func handleCheckBadges(badges: [Badge], requestTypes: [UDRequestType]) -> Bool {
        return checkBadges(badges, requestTypes: requestTypes)
    }
    
    // Alien Adventure 4
    
    func handlePolicingItems(inventory: [UDItem], policingFilter: UDItem throws -> Void) -> [UDPolicingError:Int] {
        return policingItems(inventory, policingFilter: policingFilter)
    }
    
    func handleFindTheLasers() -> (UDItem -> Bool) {
        return findTheLasers()
    }
    
    func handleRedefinePolicingItems() -> (UDItem throws -> Void) {
        return redefinePolicingItems()
    }
    
    func handleBoostItemValue(inventory: [UDItem]) -> [UDItem] {
        return boostItemValue(inventory)
    }
    
    func handleSortLeastToGreatest(inventory: [UDItem]) -> [UDItem] {
        return sortLeastToGreatest(inventory)
    }
    
    func handleGetCommonItems(inventory: [UDItem]) -> [UDItem] {
        return getCommonItems(inventory)
    }
    
    func handleTotalBaseValue(inventory: [UDItem]) -> Int {
        return totalBaseValue(inventory)
    }
    
    func handleRemoveDuplicates(inventory: [UDItem]) -> [UDItem] {
        return removeDuplicates(inventory)
    }    
}