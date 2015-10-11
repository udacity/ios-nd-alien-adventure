//
//  SpecialBadge.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit
import Foundation

enum BadgeAnimation: Int {
    case GrowAndShrink, Rotate, Shake
}

class SpecialBadge: Badge {
    
    override init(requestType: UDRequestType) {
        super.init(requestType: requestType)
        self.texture = SKTexture(imageNamed: "BadgeTeal")
        
        let randomAnimation = BadgeAnimation(rawValue: Int(arc4random_uniform(3)))!
        
        switch(randomAnimation) {
        case .GrowAndShrink:
            let shrink = SKAction.scaleTo(0.8, duration: 1.0)
            let grow = SKAction.scaleTo(1.1, duration: 1.0)
            let growAndShrink = SKAction.sequence([shrink, grow])
            runAction(SKAction.repeatActionForever(growAndShrink))
        case .Rotate:
            let rotate = SKAction.rotateByAngle(CGFloat(-M_PI), duration: 1.5)
            runAction(SKAction.repeatActionForever(rotate))
        case .Shake:
            // Snippet adapted from code found in this blog post: www.thinkingswiftly.com/camera-shake-with-spritekit-in-swift/
            let amplitudeX: Float = 10;
            let amplitudeY: Float = 6;
            let numberOfShakes = 2.0 / 0.04;
            var actionsArray = [SKAction]()
            for _ in 1...Int(numberOfShakes) {
                let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
                let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
                let shakeAction = SKAction.moveByX(CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
                actionsArray.append(shakeAction);
                actionsArray.append(shakeAction.reversedAction());
            }
            let shake = SKAction.sequence(actionsArray);
            runAction(SKAction.repeatActionForever(shake))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}