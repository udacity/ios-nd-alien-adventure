//
//  PlanetData.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//
import Foundation

extension Hero {
    
    func planetData(dataFile: String) -> String {

        let planetDataURL = NSBundle.mainBundle().URLForResource("PlanetData", withExtension: "json")!
        
        let planetData = NSData(contentsOfURL: planetDataURL)!
        
        var planetDataArray: NSArray!
        do {
            planetDataArray = try! NSJSONSerialization.JSONObjectWithData(planetData, options: .AllowFragments) as! NSArray
        }

        var highestValue = 0
        var highestValuePlanet = ""
        
        let planetDictionaries = planetDataArray as! [[String:AnyObject]]
        
        for planet in planetDictionaries {
            
            var planetValue = 0
            
            guard let planetName = planet["Name"] as? String else {
                continue
            }
            
            if let commonItemsDetected = planet["CommonItemsDetected"] as? Int {
                planetValue += commonItemsDetected
            }
            
            if let uncommonItemsDetected = planet["UncommonItemsDetected"] as? Int {
                planetValue += uncommonItemsDetected * 2
            }
            
            if let rareItemsDetected = planet["RareItemsDetected"] as? Int {
                planetValue += rareItemsDetected * 3
            }
            
            if let legendaryItemsDetected = planet["LegendaryItemsDetected"] as? Int {
                planetValue += legendaryItemsDetected * 4
            }

            if planetValue > highestValue {
                highestValue = planetValue
                highestValuePlanet = planetName
            }
        }
        
        return highestValuePlanet
    }
}
