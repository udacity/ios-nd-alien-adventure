//
//  UDCollision.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/1/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - UDCollisionCategory

enum UDCollisionCategory: UInt32 {
    case Player = 1
    case World = 2
}

// MARK: - UDCollision

class UDCollision {
            
    class func setCollisionForPhysicsBody(physicsBody: SKPhysicsBody, belongsToMask: UDCollisionCategory, contactWithMask: UDCollisionCategory, dynamic: Bool = false) {
        physicsBody.dynamic = dynamic
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.categoryBitMask = belongsToMask.rawValue
        physicsBody.collisionBitMask = 0
        physicsBody.contactTestBitMask = contactWithMask.rawValue
    }
}
