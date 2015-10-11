//
//  AlienAdventure3.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - RequestTester (Alien Adventure 3 Tests)

extension UDRequestTester {
    
    // MARK: BasicCheck
    
    func testBasicCheck() -> Bool {
        return delegate.handleBasicCheck()
    }
    
    // MARK: AdvancedCheck
    
    func testAdvancedCheck() -> Bool {
        return delegate.handleAdvancedCheck()
    }
    
    // MARK: ExpertCheck
    
    func testExpertCheck() -> Bool {
        return delegate.handleExpertCheck()
    }
    
    // MARK: CheckBadges
    
    func testCheckBadges() -> Bool {
        
        if let badgeManager = delegate.badgeManager {
            // check 1
            let typesToCheck1: [UDRequestType] = [.BasicCheck, .BasicCheck, .AdvancedCheck, .ExpertCheck]
            var typesFulfilled1 =  [UDRequestType]()
            for badge in badgeManager.badges {
                typesFulfilled1.append(badge.requestType)
            }
            if !delegate.handleCheckBadges(badgeManager.badges, requestTypes: typesToCheck1) {
                print("CheckBadges FAILED: If badges for are present \(typesFulfilled1) when checking for \(typesToCheck1), then the check should pass.")
                return false
            }
            
            // check 2
            let typesToCheck2: [UDRequestType] = [.BasicCheck, .BasicCheck, .AdvancedCheck, .ExpertCheck]
            let typesFulfilled2: [UDRequestType] = [.BasicCheck]
            if delegate.handleCheckBadges([Badge(requestType: .BasicCheck)], requestTypes: typesToCheck2) {
                print("CheckBadges FAILED: If badges for are present \(typesFulfilled2) when checking for \(typesToCheck2), then the check should not pass.")
                return false
            }
            
            // check 3
            let typesToCheck3: [UDRequestType] = [.BasicCheck, .ShuffleStrings]
            let typesFulfilled3: [UDRequestType] = [.BasicCheck, .ShuffleStrings, .MostCommonCharacter]
            if !delegate.handleCheckBadges([Badge(requestType: .BasicCheck), SpecialBadge(requestType: .ShuffleStrings), Badge(requestType: .MostCommonCharacter)], requestTypes: typesToCheck3) {
                print("CheckBadges FAILED: If badges for are present \(typesFulfilled3) when checking for \(typesToCheck3), then the check should pass.")
                return false
            }
            
            // check 4
            let typesToCheck4 = [UDRequestType]()
            let typesFulfilled4: [UDRequestType] = [.BasicCheck, .ShuffleStrings, .MostCommonCharacter]
            if !delegate.handleCheckBadges([Badge(requestType: .BasicCheck), SpecialBadge(requestType: .ShuffleStrings), Badge(requestType: .MostCommonCharacter)], requestTypes: typesToCheck4) {
                print("CheckBadges FAILED: If badges for are present \(typesFulfilled4) when checking for \(typesToCheck4), then the check should pass.")
                return false
            }
            
            // check 5
            let typesToCheck5: [UDRequestType] = [.BasicCheck, .ShuffleStrings]
            let typesFulfilled5 = [UDRequestType]()
            if delegate.handleCheckBadges([Badge](), requestTypes: typesToCheck5) {
                print("CheckBadges FAILED: If badges for are present \(typesFulfilled5) when checking for \(typesToCheck5), then the check should not pass.")
                return false
            }
        } else {
            return false
        }
        
        return true
    }
}

// MARK: - RequestTester (Alien Adventure 3 Process Requests)

extension UDRequestTester {
    
    // MARK: BasicCheck
    
    func processBasicCheck() -> String {
        return "Hero: [Screen was tapped. Basic check complete!]"
    }
    
    // MARK: AdvancedCheck
    
    func processAdvancedCheck() -> String {
        return "Hero: [Screen was tapped. Advanced check complete!]"
    }
    
    // MARK: ExpertCheck
    
    func processExpertCheck() -> String {
        return "Hero: [Screen was tapped. Expert check complete!]"
    }
    
    // MARK: CheckBadges
    
    func processCheckBadges(failed: Bool) -> String {
        if failed {
            return "Hero: Yeah... so it turns out I have some badges, but honestly I'm not going to tell you what I have..."
        } else {
            return "Hero: Yeah, I have those badges. See look here!"
        }
    }
}