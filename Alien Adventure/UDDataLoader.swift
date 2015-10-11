//
//  UDDataLoader.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/28/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit
import Foundation

// MARK: - UDDataError

enum UDDataError: ErrorType {
    case KeyError(String, String, String)
    case UnknownError
}

// MARK: - UDDialogueKey

enum UDDialogueKey: String {
    case StartingDialogue = "StartingDialogue"
    case RequestingDialogue = "RequestingDialogue"
    case TransitioningDialogue = "TransitioningDialogue"
    case WinningDialogue = "WinningDialogue"
    case LosingDialogue = "LosingDialogue"
}

// MARK: - UDDataLoader

class UDDataLoader {
    
    // MARK: GameDataKeys
    
    struct GameDataKeys {
        static let Items = "Items"
        static let ItemID = "ItemID"
        static let ItemType = "ItemType"
        static let ItemBaseValue = "BaseValue"
        static let ItemInscription = "Inscription"
        static let ItemRarity = "Rarity"
        static let ItemHistoricalData = "HistoricalData"
        static let ItemPlanetOfOrigin = "PlanetOfOrigin"
        static let ItemCarbonAge = "CarbonAge"
        static let Animations = "Animations"
        static let Hero = "Hero"
        static let Name = "Name"
        static let Position = "Position"
        static let Variant = "Variant"
        static let Inventory = "Inventory"
        static let Aliens = "Aliens"
        static let Requests = "Requests"
        static let Treasure = "Treasure"
        static let InitialConversation = "InitialConversation"
        static let PassConversation = "PassConversation"
        static let FailConversation = "FailConversation"
        static let RequestType = "RequestType"
        static let HeroSpriteKey = "Hero"
        static let AlienSpriteKey = "Alien"
        static let TreasureSpriteKey = "Treasure"
        static let LineText = "LineText"
        static let LineSource = "LineSource"
        static let Levels = "Levels"
        static let ShowBadges = "ShowBadges"
    }
    
    struct KeyPostfixes {
        static let AtlasFile = "AtlasFile"
        static let Frames = "Frames"
        static let TimePerFrame = "TPF"
    }
    
    // MARK: Load Level Data
    
    class func LevelDictionaryFromGameDictionary(dictionary: [String: AnyObject], level: Int) throws -> [String:AnyObject] {
        
        guard let levelArray = dictionary[GameDataKeys.Levels] as? [[String:AnyObject]] else {
            throw UDDataError.KeyError("\(level)", "\(dictionary)", __FUNCTION__)
        }
        return levelArray[level]
    }
    
    // MARK: Load Items Index
    
    class func ItemsIndexFromGameDictionary(dictionary: [String:AnyObject]) throws -> [String:UDItem] {
        
        guard let itemsDictionaries = dictionary[GameDataKeys.Items] as? [String:AnyObject] else {
            throw UDDataError.KeyError(GameDataKeys.Items, "\(dictionary)", __FUNCTION__)
        }
        
        var itemsIndex = [String:UDItem]()
        for (itemKey, itemDictionary) in itemsDictionaries {
            guard let itemDictionary = itemDictionary as? [String:AnyObject] else {
                throw UDDataError.KeyError(GameDataKeys.Items, "\(itemsDictionaries)", __FUNCTION__)
            }
            
            do {
                let item = try ItemFromDictionary(itemDictionary, name: itemKey)
                itemsIndex[itemKey] = item
            }
        }
        return itemsIndex
    }
    
    // MARK: Load Item
    
    class func ItemFromDictionary(dictionary: [String:AnyObject], name: String) throws -> UDItem {
        
        guard let itemID = dictionary[GameDataKeys.ItemID] as? Int else {
            throw UDDataError.KeyError(GameDataKeys.ItemID, "\(dictionary)", __FUNCTION__)
        }
        
        guard let itemTypeInt = dictionary[GameDataKeys.ItemType] as? Int,
            let itemType = UDItemType(rawValue: itemTypeInt) else {
                throw UDDataError.KeyError(GameDataKeys.ItemType, "\(dictionary)", __FUNCTION__)
        }
        
        guard let baseValue = dictionary[GameDataKeys.ItemBaseValue] as? Int else {
            throw UDDataError.KeyError(GameDataKeys.ItemBaseValue, "\(dictionary)", __FUNCTION__)
        }
        
        guard let rarityInt = dictionary[GameDataKeys.ItemRarity] as? Int,
            let rarity = UDItemRarity(rawValue: rarityInt) else {
                throw UDDataError.KeyError(GameDataKeys.ItemRarity, "\(dictionary)", __FUNCTION__)
        }
        
        guard let historicalData = dictionary[GameDataKeys.ItemHistoricalData] as? [String:AnyObject] else {
            throw UDDataError.KeyError(GameDataKeys.ItemHistoricalData, "\(dictionary)", __FUNCTION__)
        }
        
        if let inscription = dictionary[GameDataKeys.ItemInscription] as? String {
            return UDItem(itemID: itemID, itemType: itemType, name: name, baseValue: baseValue, inscription: inscription, rarity: rarity, historicalData: historicalData)
        } else {
            return UDItem(itemID: itemID, itemType: itemType, name: name, baseValue: baseValue, rarity: rarity, historicalData: historicalData)
        }
    }
    
    // MARK: Load Animations
    
    class func AnimationFromGameDictionary(dictionary: [String:AnyObject], spriteKey: String, animationKeyPrefix: String) throws -> UDAnimationData {
        
        guard let animationsDictionary = dictionary[GameDataKeys.Animations] as? [String:AnyObject] else {
            throw UDDataError.KeyError(GameDataKeys.Animations, "\(dictionary)", __FUNCTION__)
        }
        
        guard let spriteDictionary = animationsDictionary[spriteKey] as? [String:AnyObject] else {
            throw UDDataError.KeyError("\(spriteKey)", "\(animationsDictionary)", __FUNCTION__)
        }
        
        let atlasfileKey = animationKeyPrefix + KeyPostfixes.AtlasFile
        let framesKey = animationKeyPrefix + KeyPostfixes.Frames
        let timePerFrameKey = animationKeyPrefix + KeyPostfixes.TimePerFrame
        
        guard let atlasFile = spriteDictionary[atlasfileKey] as? String else {
            throw UDDataError.KeyError("\(atlasfileKey)", "\(spriteDictionary)", __FUNCTION__)
        }
        
        guard let frameStrings = spriteDictionary[framesKey] as? [String] else {
            throw UDDataError.KeyError("\(framesKey)", "\(spriteDictionary)", __FUNCTION__)
        }
        
        guard let timePerFrame = spriteDictionary[timePerFrameKey] as? Double else {
            throw UDDataError.KeyError("\(timePerFrameKey)", "\(spriteDictionary)", __FUNCTION__)
        }
        
        let atlas = SKTextureAtlas(named: atlasFile)
        var frames = [SKTexture]()
        
        for frame in frameStrings {
            frames.append(atlas.textureNamed(frame))
        }
        
        return UDAnimationData(atlasFile: atlasFile, frames: frames, timePerFrame: timePerFrame)
    }
    
    // MARK: Load Show Badges
    
    class func ShowBadgesFromLevelDictionary(dictionary: [String:AnyObject]) throws -> Bool {
                
        guard let showBadges = dictionary[GameDataKeys.ShowBadges] as? Bool else {
            throw UDDataError.KeyError(GameDataKeys.ShowBadges, "\(dictionary)", __FUNCTION__)
        }
        
        return showBadges
    }
    
    // MARK: Load Dialogue String (Global)
    
    class func DialogueStringFromLevelDictionary(dictionary: [String:AnyObject], key: UDDialogueKey) throws -> String {
        
        guard let dialogueString = dictionary[key.rawValue] as? String else {
            throw UDDataError.KeyError(key.rawValue, "\(dictionary)", __FUNCTION__)
        }
        return dialogueString
    }
    
    // MARK: Load Dialogue String (For Alien Request)
    
    class func LineOfDialogueFromDialogueDictionary(dictionary: [String:AnyObject], npcName: String) throws -> UDLineOfDialogue {
        
        guard let lineText = dictionary[GameDataKeys.LineText] as? String else {
            throw UDDataError.KeyError(GameDataKeys.LineText, "\(dictionary)", __FUNCTION__)
        }
        
        guard let lineSource = dictionary[GameDataKeys.LineSource] as? Int else {
            throw UDDataError.KeyError(GameDataKeys.LineSource, "\(dictionary)", __FUNCTION__)
        }
        
        return UDLineOfDialogue(lineText: (UDLineSource(rawValue: lineSource)! == .Hero) ? "\(GameDataKeys.Hero): " + lineText : "\(npcName): " + lineText, lineSource: UDLineSource(rawValue: lineSource)!)
    }
    
    // MARK: Load Conversation
    
    class func ConversationFromDialogueDictionaries(dictionaries: [[String:AnyObject]], npcName: String) throws -> UDConversation {
        
        var linesOfDialogue = [UDLineOfDialogue]()
        for dialogueDictionary in dictionaries {
            do {
                let lineOfDialogue = try LineOfDialogueFromDialogueDictionary(dialogueDictionary, npcName: npcName)
                linesOfDialogue.append(lineOfDialogue)
            }
        }
        return UDConversation(linesOfDialogue: linesOfDialogue)
    }
    
    // MARK: Load Hero
    
    class func HeroFromLevelDictionary(dictionary: [String:AnyObject]) throws -> Hero {
        
        guard let heroDictionary = dictionary[GameDataKeys.Hero] as? [String:AnyObject] else {
            throw UDDataError.KeyError(GameDataKeys.Hero, "\(dictionary)", __FUNCTION__)
        }
        
        guard let name = heroDictionary[GameDataKeys.Name] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Name, "\(dictionary)", __FUNCTION__)
        }
        
        guard let position = heroDictionary[GameDataKeys.Position] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Position, "\(dictionary)", __FUNCTION__)
        }
        
        guard let inventoryKeyArray = heroDictionary[GameDataKeys.Inventory] as? [String] else {
            throw UDDataError.KeyError(GameDataKeys.Inventory, "\(dictionary)", __FUNCTION__)
        }
        
        var items = [UDItem]()
        for item in inventoryKeyArray {
            if (UDItemIndex.items.indexForKey(item) != nil) {
                items.append(UDItemIndex.items[item]!)
            } else {
                throw UDDataError.KeyError("\(item)", "\(UDItemIndex.items)", __FUNCTION__)
            }
        }
        
        return Hero(name: name, position: CGPointFromString(position), items: items)
    }
    
    // MARK: Load Aliens
    
    class func AliensFromLevelDictionary(dictionary: [String:AnyObject]) throws -> [Alien] {
        
        guard let alienDictionaries = dictionary[GameDataKeys.Aliens] as? [[String:AnyObject]] else {
            throw UDDataError.KeyError(GameDataKeys.Aliens, "\(dictionary)", __FUNCTION__)
        }
        
        var aliens = [Alien]()
        for alienDictionary in alienDictionaries {
            do {
                let alien = try AlienFromAlienDictionary(alienDictionary)
                aliens.append(alien)
            }
        }
        
        return aliens
    }
    
    // MARK: Load Alien
    
    class func AlienFromAlienDictionary(dictionary: [String:AnyObject]) throws -> Alien {
        
        guard let name = dictionary[GameDataKeys.Name] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Name, "\(dictionary)", __FUNCTION__)
        }
        
        guard let position = dictionary[GameDataKeys.Position] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Position, "\(dictionary)", __FUNCTION__)
        }
        
        guard let variant = dictionary[GameDataKeys.Variant] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Variant, "\(dictionary)", __FUNCTION__)
        }
        
        guard let requestDictionaries = dictionary[GameDataKeys.Requests] as? [[String:AnyObject]] else {
            throw UDDataError.KeyError(GameDataKeys.Requests, "\(dictionary)", __FUNCTION__)
        }
        
        var requests = [UDRequest]()
        for requestDictionary in requestDictionaries {
            do {
                let request = try UDRequestFromUDRequestDictionary(requestDictionary, npcName: name)
                requests.append(request)
            }
        }
        
        return Alien(name: name, position: CGPointFromString(position), variant: AlienColor(rawValue: variant)!, requests: requests)
    }
    
    // MARK: Load Alien Request
    
    class func UDRequestFromUDRequestDictionary(dictionary: [String:AnyObject], npcName: String) throws -> UDRequest {
        
        guard let requestType = dictionary[GameDataKeys.RequestType] as? String else {
            throw UDDataError.KeyError(GameDataKeys.RequestType, "\(dictionary)", __FUNCTION__)
        }
        
        guard let initialConversationData = dictionary[GameDataKeys.InitialConversation] as? [[String:AnyObject]] else {
            throw UDDataError.KeyError(GameDataKeys.InitialConversation, "\(dictionary)", __FUNCTION__)
        }
        
        guard let passConversationData = dictionary[GameDataKeys.PassConversation] as? [[String:AnyObject]] else {
            throw UDDataError.KeyError(GameDataKeys.PassConversation, "\(dictionary)", __FUNCTION__)
        }
        
        guard let failConversationData = dictionary[GameDataKeys.FailConversation] as? [[String:AnyObject]] else {
            throw UDDataError.KeyError(GameDataKeys.FailConversation, "\(dictionary)", __FUNCTION__)
        }
        
        var initialConversation = UDConversation()
        var passConversation = UDConversation()
        var failConversation = UDConversation()
        
        do {
            initialConversation = try ConversationFromDialogueDictionaries(initialConversationData, npcName: npcName)
            passConversation = try ConversationFromDialogueDictionaries(passConversationData, npcName: npcName)
            failConversation = try ConversationFromDialogueDictionaries(failConversationData, npcName: npcName)
            failConversation.addLine(UDLineOfDialogue(lineText: Settings.Dialogue.LosingDialogue, lineSource: .Hero))
        }
        
        return UDRequest(requestType: UDRequestType(rawValue: requestType)!, initialConversation: initialConversation, passConversation: passConversation, failConversation: failConversation)
    }
    
    // MARK: Load Treasure
    
    class func TreasureFromLevelDictionary(dictionary: [String:AnyObject]) throws -> SKSpriteNode {
        
        guard let treasureDictionary = dictionary[GameDataKeys.Treasure] as? [String:AnyObject] else {
            throw UDDataError.KeyError(GameDataKeys.Treasure, "\(dictionary)", __FUNCTION__)
        }
        
        guard let name = treasureDictionary[GameDataKeys.Name] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Name, "\(dictionary)", __FUNCTION__)
        }
        
        guard let position = treasureDictionary[GameDataKeys.Position] as? String else {
            throw UDDataError.KeyError(GameDataKeys.Position, "\(dictionary)", __FUNCTION__)
        }
        
        let treasure = SKSpriteNode(texture: UDAnimation.baseFrameForSprite[.Treasure])
        
        treasure.size = CGSize(width: 145.5, height: 172)
        treasure.name = name
        treasure.position = CGPointFromString(position)
        treasure.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 650.0, height: 64))
        if let treasurePhysicsBody = treasure.physicsBody {
            UDCollision.setCollisionForPhysicsBody(treasurePhysicsBody, belongsToMask: .World, contactWithMask: .Player)
        }
        
        return treasure
    }
}