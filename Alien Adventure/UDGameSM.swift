//
//  UDGameSM.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDGameState

enum UDGameState {
    case DoNothing, Dialogue, DialogueAngry, Reset, Win, MoveHero
}

// MARK: - UDGameSM

class UDGameSM {
    
    // MARK: UDInternalGameState
    
    private enum UDInternalGameState {
        case NotStarted, Moving, InRequest
    }
    
    // MARK: Properties
    
    private var currentState = UDInternalGameState.InRequest
    private var requestSM: UDRequestSM!
    private var winningCondition = false
    var failedRequest: Bool {
        return requestSM.failedRequest
    }
    
    // MARK: Shared Instance
    
    class func stateMachine(delegate: UDRequestDelegate) -> UDGameSM {
        
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
    
    func startNewRequest(request: UDRequest) {
        currentState = .InRequest
        requestSM.setNewRequest(request)
    }
    
    func resetMachineWithRequest(request: UDRequest) {
        currentState = .InRequest
        requestSM.setNewRequest(request)
        winningCondition = false
    }
    
    func nextState(hero: Hero, currentAlien: Alien?) -> UDGameState {
        
        var nextState: UDInternalGameState
        var externalState: UDGameState
        
        switch(currentState) {
        case .NotStarted:
            nextState = .NotStarted
            externalState = .DoNothing
        case .Moving:
            nextState = .Moving
            externalState = .DoNothing
        case .InRequest:
            let requestState = requestSM.nextState()
            switch(requestState) {
            case .Speak:
                nextState = .InRequest
                externalState = .Dialogue
            case .SpeakAngry:
                nextState = .InRequest
                externalState = .DialogueAngry
            case .FinishRequest:
                if(failedRequest) {
                    nextState = .InRequest
                    externalState = .Reset
                } else if(winningCondition) {
                    nextState = .NotStarted
                    externalState = .Win
                } else {
                    if let currentAlien = currentAlien where Settings.Common.ShowBadges {
                        addBadge(hero, alien: currentAlien)
                    }
                    nextState = .Moving
                    externalState = .MoveHero
                }
            }
        }
        
        currentState = nextState
        return externalState
    }
}