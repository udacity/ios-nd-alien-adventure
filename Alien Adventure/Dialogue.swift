//
//  Dialogue.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/14/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - Dialogue

class Dialogue: SKNode {
    
    // MARK: Properites
    
    var text: SKMultiLabelNode!
    var background: SKSpriteNode!
    
    // MARK: Initializers
    
    init(text: String, widthOfDialogue: Int, lineSource: UDLineSource) {
        super.init()
        
        self.text = SKMultiLabelNode(text: text, labelWidth: widthOfDialogue, pos: CGPoint.zero, fontSize: 30, leading: 40)

        self.background = (lineSource == .hero) ? SKSpriteNode(imageNamed: "Dialogue-Hero") : SKSpriteNode(imageNamed: "Dialogue-Alien")
        self.background.position = CGPoint(x: self.text!.position.x, y: self.text!.position.y - 50)
        self.background.size = CGSize(width: CGFloat(self.text!.labelWidth) + 35, height: 200)
        
        self.addChild(self.background)
        self.addChild(self.text!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
