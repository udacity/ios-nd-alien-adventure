//
//  RedefinePolicingItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDPolicingError

enum UDPolicingError: ErrorType {
    case NameContainsLaser
    case ItemFromCunia
    case ValueLessThan10
}

extension Hero {
    
    func redefinePolicingItems() -> (UDItem throws -> Void) {
        
        func policingFilter(item: UDItem) throws -> Void {
            if item.name.lowercaseString.containsString("laser") {
                throw UDPolicingError.NameContainsLaser
            }
            
            if let planetOfOrigin = item.historicalData["PlanetOfOrigin"] as? String where planetOfOrigin == "Cunia" {
                throw UDPolicingError.ItemFromCunia
            }
            
            if item.baseValue < 10 {
                throw UDPolicingError.ValueLessThan10
            }
        }
        
        return policingFilter        
    }    
}
