//
//  AlienAdventureScene.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/14/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - AlienAdventureScene: SKScene

class AlienAdventureScene: SKScene {
    
    // MARK: Presenting View Controller
    
    var settingsController: UIViewController? = nil
    
    // MARK: World Nodes
    
    var world: SKNode!
    var ui: SKNode!
    var badgeManager: BadgeManager!
    var dialogueManager: DialogueManager!
    var hero: Hero!
    var aliens = [Alien]()
    var treasure: SKSpriteNode!
    
    // MARK: State
    
    var gameSM: UDGameSM!
    var currentAlien: Alien? = nil
    var winningCondition = false
    var requestsToSkip = 0
    
    // MARK: Data
    
    var levelDataDictionary: [String:AnyObject]!
    
    // MARK: Initializers
    
    override init(size: CGSize) {
        super.init(size: size)
        
        requestsToSkip = Settings.Common.RequestsToSkip
        
        let gameDataDictionary = NSDictionary(contentsOfURL: Settings.Common.GameDataURL) as! [String:AnyObject]
        
        do {
            levelDataDictionary = try UDDataLoader.LevelDictionaryFromGameDictionary(gameDataDictionary, level: Settings.Common.Level)
            UDItemIndex.items = try UDDataLoader.ItemsIndexFromGameDictionary(gameDataDictionary)
            try UDAnimation.loadAllAnimations(gameDataDictionary)
            try loadGameDataForLevel(Settings.Common.Level)
        }
        catch UDDataError.KeyError(let key, let dictionary, let source) {
            print("\(source): Cannot find key \'\(key)\'  in \(dictionary)")
        }
        catch UDDataError.UnknownError {
            print("unknown error from PListDataError")
        }
        catch {
            print("really unknown error in loadAnimations")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Load Game Data
    
    func loadGameDataForLevel(level: Int) throws {
        do {
            Settings.Dialogue.StartingDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .StartingDialogue)
            Settings.Dialogue.RequestingDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .RequestingDialogue)
            Settings.Dialogue.TransitioningDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .TransitioningDialogue)
            Settings.Dialogue.WinningDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .WinningDialogue)
            Settings.Dialogue.LosingDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .LosingDialogue)
        }
    }
    
    // MARK: Reset Game
    
    func resetGame() {
        
        if let settingsController = settingsController {
            settingsController.dismissViewControllerAnimated(true, completion: nil)
        } else {
            requestsToSkip = Settings.Common.RequestsToSkip
            world.position = CGPointMake(0.0, 0.0)
            dialogueManager.removeDialogueNode()
            
            hero.position = CGPointMake(0, -124.0)
            hero.badgeManager!.badges.removeAll(keepCapacity: true)
            hero.badgeManager!.badgeDisplay.removeAllChildren()
            hero.removeAllActions()
            hero.inventory.removeAll(keepCapacity: true)
            for item in UDDataLoader.items {
                hero.inventory.append(item)
            }
            UDAnimation.runAnimationForSprite(hero, animationKey: .HeroResting)
            
            for alien in aliens {
                alien.reset()
                alien.removeAllActions()
                let restingAnimationKey: UDAnimation.UDAnimationKey = alien.colorVariant == .Magenta ? .MagentaAlienResting : .TealAlienResting
                UDAnimation.runAnimationForSprite(alien, animationKey: restingAnimationKey)
            }
            currentAlien = nil
            
            resetSMWithRequest(UDRequest.UDRequestWithoutPassFail([UDLineOfDialogue(lineText: Settings.Dialogue.StartingDialogue, lineSource: .Hero)]), resetGame: true)
        }
    }
    
    // MARK: Move Hero
    
    func moveHero() {
        if hero.actionForKey(UDAnimation.UDAnimationKey.HeroMoving.rawValue) == nil {
            
            if let _ = hero.actionForKey(UDAnimation.UDAnimationKey.HeroResting.rawValue) {
                hero.removeActionForKey(UDAnimation.UDAnimationKey.HeroResting.rawValue)
            }
            
            let action = SKAction.moveBy(CGVectorMake(1000, 0), duration: 2.0)
            hero.runAction(action)
            UDAnimation.runAnimationForSprite(hero, animationKey: .HeroMoving)
        }
    }
}

// MARK: - AlienAdventureScene (SKScene Overrides)

extension AlienAdventureScene {
    
    override func didMoveToView(view: SKView) {
        
        // add world
        world = SKNode()
        world.position = CGPointMake(0.0, 0.0)
        addChild(world)
        
        // add background
        for index in 0...2 {
            let background = SKSpriteNode(imageNamed: Settings.Names.Background)
            background.position = CGPoint(x: index * Int(background.size.width), y: 0)
            background.name = Settings.Names.Background
            world.addChild(background)
        }
        
        // add ui
        ui = SKNode()
        ui.position = CGPointMake(0, (CGRectGetMaxY(frame)/2) - 50)
        badgeManager = BadgeManager(displayPosition: CGPointMake(0, (CGRectGetMinY(frame)) + 60), displaySize: CGSizeMake(CGFloat(Int(frame.width - 40) - 40), 64))
        ui.addChild(badgeManager)
        dialogueManager = DialogueManager(widthOfConverationNode: Int(frame.width - 40) - 40)
        ui.addChild(dialogueManager)
        world.addChild(ui)
                
        do {
            if settingsController == nil {
                Settings.Common.ShowBadges = try UDDataLoader.ShowBadgesFromLevelDictionary(levelDataDictionary)
            }
            hero = try UDDataLoader.HeroFromLevelDictionary(levelDataDictionary)
            aliens = try UDDataLoader.AliensFromLevelDictionary(levelDataDictionary)
            treasure = try UDDataLoader.TreasureFromLevelDictionary(levelDataDictionary)
        }
        catch UDDataError.KeyError(let key, let dictionary, let source) {
            print("\(source): Cannot find key \'\(key)\'  in \(dictionary)")
        }
        catch UDDataError.UnknownError {
            print("unknown error from PListDataError 2")
        }
        catch {
            print("really unknown error in didMoveToView 2")
        }
        
        // add hero
        UDAnimation.runAnimationForSprite(hero, animationKey: .HeroResting)
        gameSM = UDGameSM.stateMachine(hero)
        hero.badgeManager = badgeManager
        world.addChild(hero)
        
        // add aliens
        for alien in aliens {
            world.addChild(alien)
            switch(alien.colorVariant) {
            case .Magenta:
                UDAnimation.runAnimationForSprite(alien, animationKey: .MagentaAlienResting)
            case .Teal:
                UDAnimation.runAnimationForSprite(alien, animationKey: .TealAlienResting)
            }
        }
        
        // add treasure
        world.addChild(treasure)
        
        // start game SM
        resetSMWithRequest(UDRequest.UDRequestWithoutPassFail([UDLineOfDialogue(lineText: Settings.Dialogue.StartingDialogue, lineSource: .Hero)]))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        spinGameSM()
    }
    
    override func update(currentTime: CFTimeInterval) {
        // center world on hero
        if let sceneWithHero = hero.scene {
            let heroPositionInScene = sceneWithHero.convertPoint(hero.position, fromNode: world)
            world.position = CGPointMake(world.position.x - heroPositionInScene.x - 200, 0.0)
        }
        
        // center UI
        ui.position = CGPointMake(CGRectGetMidX(frame) - world.position.x, (CGRectGetMaxY(frame)/2) - 50)
    }
}

// MARK: - AlienAdventureScene: SKPhysicsContactDelegate

extension AlienAdventureScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        hero.removeAllActions()
        
        // hit treasure
        if contact.bodyA.node?.name == Settings.Names.Treasure || contact.bodyB.node?.name == Settings.Names.Treasure {
            
            winningCondition = true
            dialogueManager.displayNextLine(UDLineOfDialogue(lineText: Settings.Dialogue.WinningDialogue, lineSource: .Hero))
            
            UDAnimation.runAnimationForSprite(treasure, animationKey: .TreasureOpening, times: 1)
            
            hero.removeAllActions()
            UDAnimation.runAnimationForSprite(hero, animationKey: .HeroCelebrating)
        }
            // hit alien
        else if contact.bodyA.node!.dynamicType == Alien.self || contact.bodyB.node!.dynamicType == Alien.self {
            
            if contact.bodyA.node!.dynamicType == Alien.self {
                currentAlien = contact.bodyA.node as? Alien
            } else {
                currentAlien = contact.bodyB.node as? Alien
            }
            
            hero.removeAllActions()
            UDAnimation.runAnimationForSprite(hero, animationKey: .HeroResting)
            
            if let currentAlien = currentAlien {
                currentAlien.removeAllActions()
                switch(currentAlien.colorVariant) {
                case .Magenta:
                    UDAnimation.runAnimationForSprite(currentAlien, animationKey: .MagentaAlienTalking)
                case .Teal:
                    UDAnimation.runAnimationForSprite(currentAlien, animationKey: .TealAlienTalking)
                }
                resetSMWithRequest(currentAlien.getFirstRequest)
            }
        }
    }
}

// MARK: - AlienAdventureScene (State Machine)

extension AlienAdventureScene {
    
    func spinGameSM() {
        if !winningCondition {
            let gameState = gameSM.nextState(hero, currentAlien: currentAlien)
            switch(gameState) {
            case .DoNothing:
                return
            case .MoveHero:
                if let currentAlien = currentAlien, let nextRequest = currentAlien.getNextRequest {
                    gameSM.startNewRequest(nextRequest)
                    dialogueManager.displayNextLine(UDLineOfDialogue(lineText: "\(currentAlien.name!): \(Settings.Dialogue.TransitioningDialogue)", lineSource: .Alien))
                } else {
                    if let currentAlien = currentAlien {
                        currentAlien.reset()
                        currentAlien.removeAllActions()
                        switch(currentAlien.colorVariant) {
                        case .Magenta:
                            UDAnimation.runAnimationForSprite(currentAlien, animationKey: .MagentaAlienResting)
                        case .Teal:
                            UDAnimation.runAnimationForSprite(currentAlien, animationKey: .TealAlienResting)
                        }
                    }
                    dialogueManager.removeDialogueNode()
                    moveHero()
                }
            case .Dialogue:
                dialogueManager.displayNextLine(gameSM.getDialogue())
            case .DialogueAngry:
                dialogueManager.displayNextLine(gameSM.getDialogue())
                if gameSM.failedRequest {
                    if let currentAlien = currentAlien {
                        if currentAlien.actionForKey(UDAnimation.UDAnimationKey.MagentaAlienAngry.rawValue) == nil {
                            currentAlien.removeAllActions()
                            switch(currentAlien.colorVariant) {
                            case .Magenta:
                                UDAnimation.runAnimationForSprite(currentAlien, animationKey: .MagentaAlienAngry)
                            case .Teal:
                                UDAnimation.runAnimationForSprite(currentAlien, animationKey: .TealAlienAngry)
                            }
                        }
                        
                    }
                }
            case .Reset:
                resetGame()
            case .Win:
                winningCondition = true
            }
        }
    }
    
    func resetSMWithRequest(request: UDRequest, resetGame: Bool = false) {
        
        var processAsNormal = true
        
        // if a alien request is encountered and we have a skip left, then skip it!
        if requestsToSkip > 0 && request.requestType != .Undefined {
            
            let requestTester = UDRequestTester(delegate: hero)
            
            if requestTester.runTestForRequestType(request.requestType) {
                requestTester.processRequestType(request.requestType, failed: false)
            }
            
            processAsNormal = false
            requestsToSkip -= 1
        }
        
        // if not skipped, process as normal
        if processAsNormal {
            if resetGame {
                gameSM.resetMachineWithRequest(request)
            } else {
                gameSM.startNewRequest(request)
            }
            spinGameSM()
        } else { // if skipped, get the next alien request (if available) or move!
            if let currentAlien = currentAlien, let nextRequest = currentAlien.getNextRequest {
                resetSMWithRequest(nextRequest)
            } else {
                moveHero()
            }
        }
    }
}