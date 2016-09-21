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
        
        let gameDataDictionary = NSDictionary(contentsOf: Settings.Common.GameDataURL) as! [String:AnyObject]
        
        do {
            levelDataDictionary = try UDDataLoader.LevelDictionaryFromGameDictionary(gameDataDictionary, level: Settings.Common.Level)
            UDItemIndex.items = try UDDataLoader.ItemsIndexFromGameDictionary(gameDataDictionary)
            try UDAnimation.loadAllAnimations(gameDataDictionary)
            try loadGameDataForLevel(Settings.Common.Level)
        }
        catch UDDataError.keyError(let key, let dictionary, let source) {
            print("\(source): Cannot find key \'\(key)\'  in \(dictionary)")
        }
        catch UDDataError.unknownError {
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
    
    func loadGameDataForLevel(_ level: Int) throws {
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
            settingsController.dismiss(animated: true, completion: nil)
        } else {
            requestsToSkip = Settings.Common.RequestsToSkip
            world.position = CGPoint(x: 0.0, y: 0.0)
            dialogueManager.removeDialogueNode()
            
            hero.position = CGPoint(x: 0, y: -124.0)
            hero.badgeManager!.badges.removeAll(keepingCapacity: true)
            hero.badgeManager!.badgeDisplay.removeAllChildren()
            hero.removeAllActions()
            hero.inventory.removeAll(keepingCapacity: true)
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
            
            resetSMWithRequest(UDRequest.UDRequestWithoutPassFail([UDLineOfDialogue(lineText: Settings.Dialogue.StartingDialogue, lineSource: .hero)]), resetGame: true)
        }
    }
    
    // MARK: Move Hero
    
    func moveHero() {
        if hero.action(forKey: UDAnimation.UDAnimationKey.HeroMoving.rawValue) == nil {
            
            if let _ = hero.action(forKey: UDAnimation.UDAnimationKey.HeroResting.rawValue) {
                hero.removeAction(forKey: UDAnimation.UDAnimationKey.HeroResting.rawValue)
            }
            
            let action = SKAction.move(by: CGVector(dx: 1000, dy: 0), duration: 2.0)
            hero.run(action)
            UDAnimation.runAnimationForSprite(hero, animationKey: .HeroMoving)
        }
    }
}

// MARK: - AlienAdventureScene (SKScene Overrides)

extension AlienAdventureScene {
    
    override func didMove(to view: SKView) {
        
        // add world
        world = SKNode()
        world.position = CGPoint(x: 0.0, y: 0.0)
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
        ui.position = CGPoint(x: 0, y: (frame.maxY/2) - 50)
        badgeManager = BadgeManager(displayPosition: CGPoint(x: 0, y: (frame.minY) + 60), displaySize: CGSize(width: CGFloat(Int(frame.width - 40) - 40), height: 64))
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
        catch UDDataError.keyError(let key, let dictionary, let source) {
            print("\(source): Cannot find key \'\(key)\'  in \(dictionary)")
        }
        catch UDDataError.unknownError {
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
        resetSMWithRequest(UDRequest.UDRequestWithoutPassFail([UDLineOfDialogue(lineText: Settings.Dialogue.StartingDialogue, lineSource: .hero)]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spinGameSM()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // center world on hero
        if let sceneWithHero = hero.scene {
            let heroPositionInScene = sceneWithHero.convert(hero.position, from: world)
            world.position = CGPoint(x: world.position.x - heroPositionInScene.x - 200, y: 0.0)
        }
        
        // center UI
        ui.position = CGPoint(x: frame.midX - world.position.x, y: (frame.maxY/2) - 50)
    }
}

// MARK: - AlienAdventureScene: SKPhysicsContactDelegate

extension AlienAdventureScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        hero.removeAllActions()
        
        // hit treasure
        if contact.bodyA.node?.name == Settings.Names.Treasure || contact.bodyB.node?.name == Settings.Names.Treasure {
            
            winningCondition = true
            dialogueManager.displayNextLine(UDLineOfDialogue(lineText: Settings.Dialogue.WinningDialogue, lineSource: .hero))
            
            UDAnimation.runAnimationForSprite(treasure, animationKey: .TreasureOpening, times: 1)
            
            hero.removeAllActions()
            UDAnimation.runAnimationForSprite(hero, animationKey: .HeroCelebrating)
        }
            // hit alien
        else if type(of: contact.bodyA.node!) == Alien.self || type(of: contact.bodyB.node!) == Alien.self {
            
            if type(of: contact.bodyA.node!) == Alien.self {
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
            case .doNothing:
                return
            case .moveHero:
                if let currentAlien = currentAlien, let nextRequest = currentAlien.getNextRequest {
                    gameSM.startNewRequest(nextRequest)
                    dialogueManager.displayNextLine(UDLineOfDialogue(lineText: "\(currentAlien.name!): \(Settings.Dialogue.TransitioningDialogue)", lineSource: .alien))
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
            case .dialogue:
                dialogueManager.displayNextLine(gameSM.getDialogue())
            case .dialogueAngry:
                dialogueManager.displayNextLine(gameSM.getDialogue())
                if gameSM.failedRequest {
                    if let currentAlien = currentAlien {
                        if currentAlien.action(forKey: UDAnimation.UDAnimationKey.MagentaAlienAngry.rawValue) == nil {
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
            case .reset:
                resetGame()
            case .win:
                winningCondition = true
            }
        }
    }
    
    func resetSMWithRequest(_ request: UDRequest, resetGame: Bool = false) {
        
        var processAsNormal = true
        
        // if a alien request is encountered and we have a skip left, then skip it!
        if requestsToSkip > 0 && request.requestType != .undefined {
            
            let requestTester = UDRequestTester(delegate: hero)
            
            if requestTester.runTestForRequestType(request.requestType) {
                let _ = requestTester.processRequestType(request.requestType, failed: false)
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
