//
//  MostCommonCharacter.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func mostCommonCharacter(inventory: [UDItem]) -> Character? {
        
        var characterCounts = [Character:Int]()
        
        if inventory.count > 0 {
            for item in inventory {
                for character in item.name.characters {
                    if let _ = characterCounts[character] {
                        characterCounts[character]! += 1
                    } else {
                        characterCounts[character] = 1
                    }
                }
            }
        }
        
        var mostCommonCharacter: Character? = nil
        var greatestCharacterCount = 0
        
        for (character, count)  in characterCounts {
            if count > greatestCharacterCount {
                mostCommonCharacter = character
                greatestCharacterCount = count
            }
        }
        
        return mostCommonCharacter
    }
}
