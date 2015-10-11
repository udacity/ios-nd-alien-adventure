//
//  PolicingItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func policingItems(inventory: [UDItem], policingFilter: UDItem throws -> Void) -> [UDPolicingError:Int] {
        
        var errorsFound: [UDPolicingError:Int] = [
            .ItemFromCunia: 0,
            .NameContainsLaser: 0,
            .ValueLessThan10: 0
        ]
        
        for item in inventory {
            do {
                try policingFilter(item)
            }
            catch UDPolicingError.ItemFromCunia {
                errorsFound[.ItemFromCunia]! += 1
            }
            catch UDPolicingError.NameContainsLaser {
                errorsFound[.NameContainsLaser]! += 1
            }
            catch UDPolicingError.ValueLessThan10 {
                errorsFound[.ValueLessThan10]! += 1
            }
            catch {
                print("Unknown Error!")
            }
        }
        
        return errorsFound
    }    
}