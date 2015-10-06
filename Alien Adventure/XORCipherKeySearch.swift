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
        
        var key: UInt8!
        
        for x in Range<UInt8>(0..<255) {
            
            var decrypted = [UInt8]()
            
            for char in encryptedString {
                decrypted.append(char ^ x)
            }
            
            if let decryptedString = String(bytes: decrypted, encoding: NSUTF8StringEncoding) where decryptedString == "udacity" {
                key = x
                break
            }
        }
        
        return key
    }
}
