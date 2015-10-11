//
//  BadgeManager.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/8/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - DialogueManager

class BadgeManager: SKNode {
    
    // MARK: Properties
    
    var badges = [Badge]()
    var badgeDisplay: SKSpriteNode!
    
    // MARK: Initializers
    
    init(displayPosition: CGPoint, displaySize: CGSize) {
        super.init()
        badgeDisplay = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(400, 400))
        badgeDisplay.position = displayPosition
        badgeDisplay.size = displaySize        
        self.addChild(badgeDisplay)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBadge(badge: Badge) {
        badge.position = CGPoint(x: CGRectGetMinX(badgeDisplay.frame) + 32 + CGFloat(badges.count * 70), y: 0)
        badgeDisplay.addChild(badge)
        badges.append(badge)
    }
}
