//
//  DialogueManager.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/15/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - DialogueManager

class DialogueManager: SKNode {
    
    // MARK: Properties
    
    var dialogue: Dialogue!
    var widthOfDialogueNode: Int!

    // MARK: Initializers
    
    init(widthOfConverationNode: Int) {
        super.init()
        self.widthOfDialogueNode = widthOfConverationNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Display    
    
    func displayNextLine(line: UDLineOfDialogue) {
        removeDialogueNode()
        dialogue = Dialogue(text: line.lineText, widthOfDialogue: widthOfDialogueNode, lineSource: line.lineSource)
        self.addChild(dialogue)
    }
    
    func removeDialogueNode() {
        if let dialogue = dialogue {
            dialogue.removeFromParent()
        }
    }
}