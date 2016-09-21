//
//  UDRequestSM.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDRequestProgress

enum UDRequestState {
    case speak, speakAngry, finishRequest
}

// MARK: - UDRequestSM

class UDRequestSM {
    
    // MARK: UDRequestState
    
    enum UDRequestInternalState {
        case notStarted, initialConvo, processRequest, passConvo, failConvo
    }
    
    // MARK: Properties
    
    fileprivate var request: UDRequest!
    fileprivate var delegate: UDRequestDelegate!
    fileprivate var currentState = UDRequestInternalState.notStarted    
    var currentLineOfDialogue = UDLineOfDialogue(lineText: "", lineSource: .none)
    var failedRequest = false
    
    // MARK: Shared Instance
    
    class func stateMachine(_ delegate: UDRequestDelegate) -> UDRequestSM {
        
        struct Singleton {
            static var sharedInstance = UDRequestSM()
        }
        
        let stateMachine = Singleton.sharedInstance
        stateMachine.delegate = delegate
        return stateMachine
    }
    
    func setNewRequest(_ newRequest: UDRequest) {
        request = newRequest
        currentState = .initialConvo
        failedRequest = false
    }
    
    func nextState() -> UDRequestState {
        
        var nextState: UDRequestInternalState
        var externalState: UDRequestState
        
        switch(currentState) {
        case .notStarted:
            nextState = .notStarted
            externalState = .finishRequest
        case .initialConvo:
            if conversationFinished(.initial) {
                if request.requestType == .undefined {
                    nextState = .notStarted
                    externalState = .finishRequest
                } else {
                    currentLineOfDialogue = UDLineOfDialogue(lineText: Settings.Dialogue.RequestingDialogue, lineSource: .hero)
                    nextState = .processRequest
                    externalState = .speak
                }
            } else {
                currentLineOfDialogue = request.initialConversation.removeLine()!
                nextState = .initialConvo
                externalState = .speak
            }
        case .processRequest:
            let requestTester = UDRequestTester(delegate: delegate)
            failedRequest = !requestTester.runTestForRequestType(request.requestType)
            currentLineOfDialogue = UDLineOfDialogue(lineText: requestTester.processRequestType(request.requestType, failed: failedRequest), lineSource: .hero)
                        
            if failedRequest {
                nextState = .failConvo
            } else {
                nextState = .passConvo
            }            
            externalState = .speak
        case .passConvo:
            if conversationFinished(.pass) {
                nextState = .notStarted
                externalState = .finishRequest
            } else {
                currentLineOfDialogue = request!.passConversation.removeLine()!
                nextState = .passConvo
                externalState = .speak
            }
        case .failConvo:            
            if conversationFinished(.fail) {
                nextState = .notStarted
                externalState = .finishRequest
            } else {
                currentLineOfDialogue = request!.failConversation.removeLine()!
                nextState = .failConvo
                externalState = .speakAngry
            }
        }
        
        currentState = nextState
        return externalState
    }
    
    fileprivate func conversationFinished(_ type: UDConversationType) -> Bool {
        guard let request = request else {
            return true
        }
        
        switch(type) {
        case .initial:
            return request.initialConversation.finished
        case .pass:
            return request.passConversation.finished
        case .fail:
            return request.failConversation.finished
        }
    }
}
