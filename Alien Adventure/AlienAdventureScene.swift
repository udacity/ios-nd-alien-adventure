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
    
    // MARK: World Nodes
    
    var world: SKNode!
    var ui: SKNode!
    var dialogueManager: DialogueManager!
    var hero: Hero!
    var treasure: SKSpriteNode!    
    
    // MARK: State
    
    var gameSM: UDGameSM!
    var currentAlien: Alien? = nil
    var winningCondition = false

    // MARK: Data
    
    var levelDataDictionary: [String:AnyObject]!

    // MARK: Initializers
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let gameDataDictionary = NSDictionary(contentsOfURL: Settings.Common.GameDataURL) as! [String:AnyObject]
        
        do {
            levelDataDictionary = try UDDataLoader.LevelDictionaryFromGameDictionary(gameDataDictionary, level: Settings.Common.Level)
            UDItemIndex.items = try UDDataLoader.ItemsIndexFromGameDictionary(gameDataDictionary)
            try loadGameDataForLevel(Settings.Common.Level)
        }
        catch UDDataError.KeyError(let key, let dictionary) {
            print("Cannot find key \'\(key)\'  in \(dictionary)")
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
            try UDAnimation.loadAllAnimations(levelDataDictionary)
            Settings.Dialogue.StartingDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .StartingDialogue)
            Settings.Dialogue.RequestingDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .RequestingDialogue)
            Settings.Dialogue.TransitioningDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .TransitioningDialogue)
            Settings.Dialogue.WinningDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .WinningDialogue)
            Settings.Dialogue.LosingDialogue = try UDDataLoader.DialogueStringFromLevelDictionary(levelDataDictionary, key: .LosingDialogue)
        }
    }
    
    // MARK: Reset Game
    
    func resetGame() {
        world.position = CGPointMake(0.0, 0.0)
        dialogueManager.removeDialogueNode()
        
        hero.position = CGPointMake(0, -124.0)
        hero.removeAllActions()
        UDAnimation.runAnimationForSprite(hero, animationKey: .HeroResting)
        
        if let currentAlien = currentAlien {
            currentAlien.removeAllActions()
            UDAnimation.runAnimationForSprite(currentAlien, animationKey: .AlienResting)
        }
        currentAlien = nil
 
        resetSMWithRequest(UDRequest.UDRequestWithoutPassFail([UDLineOfDialogue(lineText: Settings.Dialogue.StartingDialogue, lineSource: .Hero)]), resetGame: true)
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
        dialogueManager = DialogueManager(widthOfConverationNode: Int(frame.width - 40) - 40)
        ui.addChild(dialogueManager)
        world.addChild(ui)
        
        var aliens = [Alien]()
        do {
            hero = try UDDataLoader.HeroFromLevelDictionary(levelDataDictionary)
            aliens = try UDDataLoader.AliensFromLevelDictionary(levelDataDictionary)
            treasure = try UDDataLoader.TreasureFromLevelDictionary(levelDataDictionary)
        }
        catch UDDataError.KeyError(let key, let dictionary) {
            print("Cannot find key \'\(key)\'  in \(dictionary)")
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
        world.addChild(hero)
        
        // add aliens
        for alien in aliens {
            world.addChild(alien)
            UDAnimation.runAnimationForSprite(alien, animationKey: .AlienResting)
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
                UDAnimation.runAnimationForSprite(currentAlien, animationKey: .AlienTalking)
                resetSMWithRequest(currentAlien.getFirstRequest)
            }
        }
    }
}

// MARK: - AlienAdventureScene (State Machine)

extension AlienAdventureScene {
    
    func spinGameSM() {
        if !winningCondition {
            let gameState = gameSM.nextState()
            switch(gameState) {
            case .DoNothing:
                return
            case .MoveHero:
                if let currentAlien = currentAlien, let nextRequest = currentAlien.getNextRequest {
                    gameSM.startNewRequest(nextRequest)
                    dialogueManager.displayNextLine(UDLineOfDialogue(lineText: "\(currentAlien.name!): \(Settings.Dialogue.TransitioningDialogue)", lineSource: .Alien))
                } else {
                    if let currentAlien = currentAlien {
                        currentAlien.removeAllActions()
                        UDAnimation.runAnimationForSprite(currentAlien, animationKey: .AlienResting)
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
                        if currentAlien.actionForKey(UDAnimation.UDAnimationKey.AlienAngry.rawValue) == nil {
                            currentAlien.removeAllActions()
                            UDAnimation.runAnimationForSprite(currentAlien, animationKey: .AlienAngry)
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
        if resetGame {
            gameSM.resetMachineWithRequest(request)
        } else {
            gameSM.startNewRequest(request)
        }
        spinGameSM()
    }
}