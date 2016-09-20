//
//  UDGameSM.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDGameState

enum UDGameState {
    case doNothing, dialogue, dialogueAngry, reset, win, moveHero
}

// MARK: - UDGameSM

class UDGameSM {
    
    // MARK: UDInternalGameState
    
    fileprivate enum UDInternalGameState {
        case notStarted, moving, inRequest
    }
    
    // MARK: Properties
    
    fileprivate var currentState = UDInternalGameState.inRequest
    fileprivate var requestSM: UDRequestSM!
    fileprivate var winningCondition = false
    var failedRequest: Bool {
        return requestSM.failedRequest
    }
    
    // MARK: Shared Instance
    
    class func stateMachine(_ delegate: UDRequestDelegate) -> UDGameSM {
        
        struct Singleton {
            static var sharedInstance = UDGameSM()
        }
        
        let stateMachine = Singleton.sharedInstance
        stateMachine.requestSM = UDRequestSM.stateMachine(delegate)
        return stateMachine
    }

    // MARK: Access Request SM
    
    func getDialogue() -> UDLineOfDialogue {
        return requestSM.currentLineOfDialogue
    }
    
    // MARK: Update SM
    
    func startNewRequest(_ request: UDRequest) {
        currentState = .inRequest
        requestSM.setNewRequest(request)
    }
    
    func resetMachineWithRequest(_ request: UDRequest) {
        currentState = .inRequest
        requestSM.setNewRequest(request)
        winningCondition = false
    }
    
    func nextState(_ hero: Hero, currentAlien: Alien?) -> UDGameState {
        
        var nextState: UDInternalGameState
        var externalState: UDGameState
        
        switch(currentState) {
        case .notStarted:
            nextState = .notStarted
            externalState = .doNothing
        case .moving:
            nextState = .moving
            externalState = .doNothing
        case .inRequest:
            let requestState = requestSM.nextState()
            switch(requestState) {
            case .speak:
                nextState = .inRequest
                externalState = .dialogue
            case .speakAngry:
                nextState = .inRequest
                externalState = .dialogueAngry
            case .finishRequest:
                if(failedRequest) {
                    nextState = .inRequest
                    externalState = .reset
                } else if(winningCondition) {
                    nextState = .notStarted
                    externalState = .win
                } else {
                    if let currentAlien = currentAlien, Settings.Common.ShowBadges {
                        addBadge(hero: hero, alien: currentAlien)
                    }
                    nextState = .moving
                    externalState = .moveHero
                }
            }
        }
        
        currentState = nextState
        return externalState
    }
}
