//
//  UDAnimationManager.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/28/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - UDAnimationData

struct UDAnimationData {
    let atlasFile: String
    let frames: [SKTexture]
    let timePerFrame: NSTimeInterval
}

// MARK: - UDAnimation

class UDAnimation {
    
    static var animations = [UDAnimationKey:UDAnimationData]()
    static var baseFrameForSprite = [UDSpriteKey:SKTexture]()
    
    // MARK: UDAnimationPrefix
    
    enum UDAnimationPrefix: String {
        case Resting = "Resting"
        case Moving = "Moving"
        case Celebrating = "Celebrating"
        case Talking = "Talking"
        case Angry = "Angry"
        case Opening = "Opening"
    }
    
    // MARK: UDAnimationKey
    
    enum UDAnimationKey: String {
        case HeroResting = "HeroResting"
        case HeroMoving = "HeroMoving"
        case HeroCelebrating = "HeroCelebrating"
        case AlienResting = "AlienResting"
        case AlienTalking = "AlienTalking"
        case AlienAngry = "AlienAngry"
        case TreasureOpening = "TreasureOpening"
    }
    
    // MARK: UDSpriteKey
    
    enum UDSpriteKey: String {
        case Hero = "Hero"
        case Alien = "Aliens"
        case Treasure = "Treasure"
    }
    
    // MARK: Return Animation Actions
    
    class func runAnimationForSprite(sprite: SKSpriteNode, animationKey: UDAnimationKey, times: Int = 0) {
        if let animation = animations[animationKey] {
            if times == 0 {
                sprite.runAction(SKAction.repeatActionForever(
                    SKAction.animateWithTextures(animation.frames,
                        timePerFrame: animation.timePerFrame,
                        resize: false,
                        restore: true)))
            } else {
                sprite.runAction(SKAction.repeatAction(SKAction.animateWithTextures(animation.frames,
                    timePerFrame: animation.timePerFrame,
                    resize: false,
                    restore: false), count: 1))
            }
        }
    }
    
    // MARK: Load Animation Data
    
    class func loadAllAnimations(levelDataDictionary: [String:AnyObject]) throws {
        do {
            // for hero
            try loadAnimation(levelDataDictionary, animationKey: .HeroResting, spriteKey: .Hero, animationKeyPrefix: .Resting)
            try loadAnimation(levelDataDictionary, animationKey: .HeroMoving, spriteKey: .Hero, animationKeyPrefix: .Moving)
            try loadAnimation(levelDataDictionary, animationKey: .HeroCelebrating, spriteKey: .Hero, animationKeyPrefix: .Celebrating)
            setBaseFrameForSpritesWithKey(.Hero, withAnimation: animations[.HeroResting]!.frames)
            
            // for alien
            try loadAnimation(levelDataDictionary, animationKey: .AlienResting, spriteKey: .Alien, animationKeyPrefix: .Resting)
            try loadAnimation(levelDataDictionary, animationKey: .AlienTalking, spriteKey: .Alien, animationKeyPrefix: .Talking)
            try loadAnimation(levelDataDictionary, animationKey: .AlienAngry, spriteKey: .Alien, animationKeyPrefix: .Angry)
            setBaseFrameForSpritesWithKey(.Alien, withAnimation: animations[.AlienResting]!.frames)
            
            // for treasure
            try loadAnimation(levelDataDictionary, animationKey: .TreasureOpening, spriteKey: .Treasure, animationKeyPrefix: .Opening)
            setBaseFrameForSpritesWithKey(.Treasure, withAnimation: animations[.TreasureOpening]!.frames)
        }
    }
    
    private class func loadAnimation(levelDataDictionary: [String:AnyObject], animationKey: UDAnimationKey, spriteKey: UDSpriteKey, animationKeyPrefix: UDAnimationPrefix) throws {
        do {
            let animationFromPList = try UDDataLoader.AnimationFromLevelDictionary(levelDataDictionary, spriteKey: spriteKey.rawValue, animationKeyPrefix: animationKeyPrefix.rawValue)
            animations[animationKey] = animationFromPList
        }
    }
    
    // MARK: Set Base Frames
    
    private class func setBaseFrameForSpritesWithKey(spriteKey: UDSpriteKey, withAnimation: [SKTexture]) {
        baseFrameForSprite[spriteKey] = withAnimation[0]
    }
}
