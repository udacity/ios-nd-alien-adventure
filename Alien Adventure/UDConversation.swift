//
//  UDConversation.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/28/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDConversationType

enum UDConversationType {
    case Initial, Pass, Fail
}

// MARK: - UDConversation

struct UDConversation {
    
    // MARK: Properties
    
    var linesOfDialogue: [UDLineOfDialogue]
    var finished: Bool {
        return linesOfDialogue.count == 0
    }
    
    // MARK: Initializers
    
    init() {
        linesOfDialogue = [UDLineOfDialogue]()
    }
    
    init(linesOfDialogue: [UDLineOfDialogue]) {
        self.linesOfDialogue = linesOfDialogue
    }
    
    // MARK: Remove Line
    
    mutating func removeLine() -> UDLineOfDialogue? {
        if linesOfDialogue.count > 0 {
            return linesOfDialogue.removeFirst()
        } else {
            return nil
        }
    }
    
    // MARK: Add Line
    
    mutating func addLine(lineOfDialogue: UDLineOfDialogue) {
        linesOfDialogue.append(lineOfDialogue)
    }
}

// MARK: - UDConversation: CustomStringConvertible

extension UDConversation: CustomStringConvertible {
    var description : String {
        var result = ""
        if linesOfDialogue.count > 0 {
            for line in linesOfDialogue {
                result += "\(line.lineText)\n"
            }
        } else {
            result = "[empty]"
        }        
        return result
    }
}