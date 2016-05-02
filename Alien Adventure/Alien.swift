//
//  Alien.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/16/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - AlienColor

enum AlienColor: String {
    case Magenta = "Magenta"
    case Teal = "Teal"
}

// MARK: - Alien: SKSpriteNode

class Alien: SKSpriteNode {
    
    // MARK: Properties
    
    private var currentRequestIndex = 0
    var requests: [UDRequest]!
    var colorVariant: AlienColor
    var getFirstRequest: UDRequest {
        return requests[0]
    }
    var getNextRequest: UDRequest? {
        currentRequestIndex += 1
        if currentRequestIndex < requests.count {
            return requests[currentRequestIndex]
        } else {
            return nil
        }
    }
    var currentRequestType: UDRequestType {
        return requests[currentRequestIndex].requestType
    }
    
    // MARK: Initializers
    
    init(name: String, position: CGPoint, variant: AlienColor, requests: [UDRequest]) {
        
        var spriteKey: UDSpriteKey
        switch(variant) {
        case .Magenta:
            spriteKey = .MagentaAlien
        case .Teal:
            spriteKey = .TealAlien
        }
        
        self.colorVariant = variant
        super.init(texture: UDAnimation.baseFrameForSprite[spriteKey], color: UIColor.blueColor(), size: CGSize(width: 172.5, height: 254))
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 650.0, height: 254))
        if let alienPhysicsBody = self.physicsBody {
            UDCollision.setCollisionForPhysicsBody(alienPhysicsBody, belongsToMask: .World, contactWithMask: .Player)
        }
        
        self.name = name
        self.position = position
        self.requests = requests
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        currentRequestIndex = 0
    }
}