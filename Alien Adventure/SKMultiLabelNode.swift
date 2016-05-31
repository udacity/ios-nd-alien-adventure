//
//  SKMultiLabelNode.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/14/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import SpriteKit

// MARK: - SKMultiLabelNode: SKNode

class SKMultiLabelNode: SKNode {
    
    // MARK: Properties
    
    var labelHeight = 0
    var dontUpdate = false
    
    // display objects
    var rect: SKShapeNode?
    var labels = [SKLabelNode]()
    
    // if these properties are changed, then run update()!
    var labelWidth: Int { didSet { update() } }
    var text: String { didSet { update() } }
    var fontName: String { didSet { update() } }
    var fontSize: CGFloat { didSet { update() } }
    var pos: CGPoint { didSet { update() } }
    var fontColor: UIColor { didSet { update() } }
    var leading: Int { didSet { update() } }
    var alignment: SKLabelHorizontalAlignmentMode { didSet { update() } }
    
    // MARK: Initializers
    
    init(text: String, labelWidth: Int, pos: CGPoint, fontName: String = "Superclarendon-Italic", fontSize: CGFloat, fontColor: UIColor = UIColor.whiteColor(), leading: Int, alignment: SKLabelHorizontalAlignmentMode = .Left) {
                
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = leading
        self.alignment = alignment
        
        super.init()
        
        self.update()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Update Label
    
    // If you want to change properties without updating the text field, set dontUpdate to false and call the update method manually.
    func update() {
        if (dontUpdate) { return }
        
        if (labels.count > 0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        
        let separators = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let words = text.componentsSeparatedByCharactersInSet(separators)
        
        var finalLine = false
        var wordCount = -1
        var lineCount = 0
        
        while (!finalLine) {
            lineCount += 1
            var lineLength = CGFloat(0)
            var lineString = ""
            var lineStringBeforeAddingWord = ""
            
            // creation of the SKLabelNode itself
            let label = SKLabelNode(fontNamed: fontName)
            
            // name each label node so you can animate it if u wish
            label.name = "line\(lineCount)"
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = fontColor

            while lineLength < CGFloat(labelWidth)
            {
                wordCount += 1
                if wordCount > words.count-1
                {
                    finalLine = true
                    break
                }
                else
                {
                    lineStringBeforeAddingWord = lineString
                    lineString = "\(lineString) \(words[wordCount])"
                    label.text = lineString
                    lineLength = label.frame.width
                }
            }
            if lineLength > 0 {
                wordCount -= 1
                if (!finalLine) {
                    lineString = lineStringBeforeAddingWord
                }
                label.text = lineString
                var linePos = pos
                if (alignment == .Left) {
                    linePos.x -= CGFloat(labelWidth / 2)
                } else if (alignment == .Right) {
                    linePos.x += CGFloat(labelWidth / 2)
                }
                if lineCount == 1 {
                   linePos.y += 0
                } else {
                   linePos.y += CGFloat(-leading * (lineCount - 1))
                }
                label.position = CGPointMake( linePos.x , linePos.y )
                self.addChild(label)
                labels.append(label)
            }
            
        }
        labelHeight = lineCount * leading
    }
}