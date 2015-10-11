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

// MARK: - UDSpriteKey

enum UDSpriteKey: String {
    case Hero = "Hero"
    case MagentaAlien = "MagentaAlien"
    case TealAlien = "TealAlien"
    case Treasure = "Treasure"
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
        case MagentaAlienResting = "MagentaAlienResting"
        case MagentaAlienTalking = "MagentaAlienTalking"
        case MagentaAlienAngry = "MagentaAlienAngry"
        case TealAlienResting = "TealAlienResting"
        case TealAlienTalking = "TealAlienTalking"
        case TealAlienAngry = "TealAlienAngry"
        case TreasureOpening = "TreasureOpening"
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
    
    class func loadAllAnimations(gameDataDictionary: [String:AnyObject]) throws {
        do {
            // for hero
            try loadAnimation(gameDataDictionary, animationKey: .HeroResting, spriteKey: .Hero, animationKeyPrefix: .Resting)
            try loadAnimation(gameDataDictionary, animationKey: .HeroMoving, spriteKey: .Hero, animationKeyPrefix: .Moving)
            try loadAnimation(gameDataDictionary, animationKey: .HeroCelebrating, spriteKey: .Hero, animationKeyPrefix: .Celebrating)
            setBaseFrameForSpritesWithKey(.Hero, withAnimation: animations[.HeroResting]!.frames)
            
            // for magenta alien
            try loadAnimation(gameDataDictionary, animationKey: .MagentaAlienResting, spriteKey: .MagentaAlien, animationKeyPrefix: .Resting)
            try loadAnimation(gameDataDictionary, animationKey: .MagentaAlienTalking, spriteKey: .MagentaAlien, animationKeyPrefix: .Talking)
            try loadAnimation(gameDataDictionary, animationKey: .MagentaAlienAngry, spriteKey: .MagentaAlien, animationKeyPrefix: .Angry)
            setBaseFrameForSpritesWithKey(.MagentaAlien, withAnimation: animations[.MagentaAlienResting]!.frames)
            
            // for teal alien
            try loadAnimation(gameDataDictionary, animationKey: .TealAlienResting, spriteKey: .TealAlien, animationKeyPrefix: .Resting)
            try loadAnimation(gameDataDictionary, animationKey: .TealAlienTalking, spriteKey: .TealAlien, animationKeyPrefix: .Talking)
            try loadAnimation(gameDataDictionary, animationKey: .TealAlienAngry, spriteKey: .TealAlien, animationKeyPrefix: .Angry)
            setBaseFrameForSpritesWithKey(.TealAlien, withAnimation: animations[.TealAlienResting]!.frames)
            
            // for treasure
            try loadAnimation(gameDataDictionary, animationKey: .TreasureOpening, spriteKey: .Treasure, animationKeyPrefix: .Opening)
            setBaseFrameForSpritesWithKey(.Treasure, withAnimation: animations[.TreasureOpening]!.frames)
        }
    }
    
    private class func loadAnimation(gameDataDictionary: [String:AnyObject], animationKey: UDAnimationKey, spriteKey: UDSpriteKey, animationKeyPrefix: UDAnimationPrefix) throws {
        do {
            let animationFromPList = try UDDataLoader.AnimationFromGameDictionary(gameDataDictionary, spriteKey: spriteKey.rawValue, animationKeyPrefix: animationKeyPrefix.rawValue)
            animations[animationKey] = animationFromPList
        }
    }
    
    // MARK: Set Base Frames
    
    private class func setBaseFrameForSpritesWithKey(spriteKey: UDSpriteKey, withAnimation: [SKTexture]) {
        baseFrameForSprite[spriteKey] = withAnimation[0]
    }
}
