//
//  XORCipherKeySearch.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

extension Hero {
    
    func xorCipherKeySearch(encryptedString: [UInt8]) -> UInt8 {
        
        // NOTE: This code doesn't exactly mimic what is in the Lesson. We've
        // added some print statements so that there are no warnings for 
        // unused variables 😀.
        var key: UInt8
        key = 0
        
        for x in UInt8.min..<UInt8.max {
            
            print(x)
            
            var decrypted: [UInt8]
            decrypted = [UInt8]()
            
            for character in encryptedString {
                // ADD CODE: perform decryption
                print(character)
            }
            
            if let decryptedString = String(bytes: decrypted,
                encoding: NSUTF8StringEncoding) where decryptedString == "udacity" {
                    // ADD CODE: found match, now what?
            }
        }
        
        return key
    }
}

// If you have completed this function and it is working correctly, feel free to skip this part of the adventure by opening the "Under the Hood" folder, and making the following change in Settings.swift: "static var RequestsToSkip = 3"