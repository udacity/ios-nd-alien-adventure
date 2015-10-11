//
//  FindTheLasers.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func findTheLasers() -> (UDItem -> Bool) {
        
        func hasLaserFilter(item: UDItem) -> Bool {
            return item.name.lowercaseString.containsString("laser")
        }
        
        return hasLaserFilter
    }
    
}
