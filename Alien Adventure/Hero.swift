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
        super.init(texture: UDAnimation.baseFrameForSprite[.Hero], color: UIColor.clear, size: CGSize(width: 225, height: 175))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 225, height: 175))
        if let heroPhysicsBody = self.physicsBody {
            UDCollision.setCollisionForPhysicsBody(heroPhysicsBody, belongsToMask: .player, contactWithMask: .world, dynamic: true)
        }
        
        self.name = name
        self.position = position
        self.inventory = items
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Handling Requests Not Seen By Students
    
    func checkItemComparison(_ item1: UDItem, item2: UDItem) -> Bool {
        return item1 < item2
    }

    // Adding Badges
    
    func addBadge(_ badge: Badge) {
        if let badgeManager = badgeManager {
            badgeManager.addBadge(badge)
        }
    }
}

extension Hero: UDRequestDelegate {
    
    // Alien Adventure 1
    
    func handleReverseLongestName(_ inventory: [UDItem]) -> String {
        return reverseLongestName(inventory: inventory)
    }
    
    func handleMatchMoonRocks(_ inventory: [UDItem]) -> [UDItem] {
        return matchMoonRocks(inventory: inventory)
    }
    
    func handleInscriptionEternalStar(_ inventory: [UDItem]) -> UDItem? {
        return inscriptionEternalStar(inventory: inventory)
    }
    
    func handleLeastValuableItem(_ inventory: [UDItem]) -> UDItem? {
        return leastValuableItem(inventory: inventory)
    }
    
    func handleShuffleStrings(_ s1: String, s2: String, shuffle: String) -> Bool {
        return shuffleStrings(s1: s1, s2: s2, shuffle: shuffle)
    }
    
    // Alien Adventure 2
    
    func handleItemsFromPlanet(_ inventory: [UDItem], planet: String) -> [UDItem] {
        return itemsFromPlanet(inventory: inventory, planet: planet)
    }
    
    func handleOldestItemFromPlanet(_ inventory: [UDItem], planet: String) -> UDItem? {
        return oldestItemFromPlanet(inventory: inventory, planet: planet)
    }
    
    func handleXORCipherKeySearch(_ encryptedString: [UInt8]) -> UInt8 {
        return xorCipherKeySearch(encryptedString: encryptedString)
    }
    
    func handleRarityOfItems(_ inventory: [UDItem]) -> [UDItemRarity:Int] {
        return rarityOfItems(inventory: inventory)
    }
    
    func handleItemComparison(_ item1: UDItem, item2: UDItem) -> Bool {
        return checkItemComparison(item1, item2: item2)
    }
    
    func handleBannedItems(_ dataFile: String) -> [Int] {
        return bannedItems(dataFile: dataFile)
    }
    
    func handlePlanetData(_ dataFile: String) -> String {
        return planetData(dataFile: dataFile)
    }
    
    func handleMostCommonCharacter(_ inventory: [UDItem]) -> Character? {
        return mostCommonCharacter(inventory: inventory)
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
    
    func handleCheckBadges(_ badges: [Badge], requestTypes: [UDRequestType]) -> Bool {
        return checkBadges(badges: badges, requestTypes: requestTypes)
    }
    
    // Alien Adventure 4
    
    func handlePolicingItems(_ inventory: [UDItem], policingFilter: (UDItem) throws -> Void) -> [UDPolicingError:Int] {
        return policingItems(inventory: inventory, policingFilter: policingFilter)
    }
    
    func handleFindTheLasers() -> ((UDItem) -> Bool) {
        return findTheLasers()
    }
    
    func handleRedefinePolicingItems() -> ((UDItem) throws -> Void) {
        return redefinePolicingItems()
    }
    
    func handleBoostItemValue(_ inventory: [UDItem]) -> [UDItem] {
        return boostItemValue(inventory: inventory)
    }
    
    func handleSortLeastToGreatest(_ inventory: [UDItem]) -> [UDItem] {
        return sortLeastToGreatest(inventory: inventory)
    }
    
    func handleGetCommonItems(_ inventory: [UDItem]) -> [UDItem] {
        return getCommonItems(inventory: inventory)
    }
    
    func handleTotalBaseValue(_ inventory: [UDItem]) -> Int {
        return totalBaseValue(inventory: inventory)
    }
    
    func handleRemoveDuplicates(_ inventory: [UDItem]) -> [UDItem] {
        return removeDuplicates(inventory: inventory)
    }    
}
