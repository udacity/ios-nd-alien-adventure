//
//  UDRequestSM.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - UDRequestProgress

enum UDRequestState {
    case Speak, SpeakAngry, FinishRequest
}

// MARK: - UDRequestSM

class UDRequestSM {
    
    // MARK: UDRequestState
    
    enum UDRequestInternalState {
        case NotStarted, InitialConvo, ProcessRequest, PassConvo, FailConvo
    }
    
    // MARK: Properties
    
    private var request: UDRequest!
    private var delegate: UDRequestDelegate!
    private var currentState = UDRequestInternalState.NotStarted    
    var currentLineOfDialogue = UDLineOfDialogue(lineText: "", lineSource: .None)
    var failedRequest = false
    
    // MARK: Shared Instance
    
    class func stateMachine(delegate: UDRequestDelegate) -> UDRequestSM {
        
        struct Singleton {
            static var sharedInstance = UDRequestSM()
        }
        
        let stateMachine = Singleton.sharedInstance
        stateMachine.delegate = delegate
        return stateMachine
    }
    
    func setNewRequest(newRequest: UDRequest) {
        request = newRequest
        currentState = .InitialConvo
        failedRequest = false
    }
    
    func nextState() -> UDRequestState {
        
        var nextState: UDRequestInternalState
        var externalState: UDRequestState
        
        switch(currentState) {
        case .NotStarted:
            nextState = .NotStarted
            externalState = .FinishRequest
        case .InitialConvo:
            if conversationFinished(.Initial) {
                if request.requestType == .Undefined {
                    nextState = .NotStarted
                    externalState = .FinishRequest
                } else {
                    currentLineOfDialogue = UDLineOfDialogue(lineText: Settings.Dialogue.RequestingDialogue, lineSource: .Hero)
                    nextState = .ProcessRequest
                    externalState = .Speak
                }
            } else {
                currentLineOfDialogue = request.initialConversation.removeLine()!
                nextState = .InitialConvo
                externalState = .Speak
            }
        case .ProcessRequest:
            let requestTester = UDRequestTester(delegate: delegate)
            failedRequest = !requestTester.runTestForRequestType(request.requestType)
            currentLineOfDialogue = UDLineOfDialogue(lineText: requestTester.processRequestType(request.requestType, failed: failedRequest), lineSource: .Hero)
                        
            if failedRequest {
                nextState = .FailConvo
            } else {
                nextState = .PassConvo
            }            
            externalState = .Speak
        case .PassConvo:
            if conversationFinished(.Pass) {
                nextState = .NotStarted
                externalState = .FinishRequest
            } else {
                currentLineOfDialogue = request!.passConversation.removeLine()!
                nextState = .PassConvo
                externalState = .Speak
            }
        case .FailConvo:            
            if conversationFinished(.Fail) {
                nextState = .NotStarted
                externalState = .FinishRequest
            } else {
                currentLineOfDialogue = request!.failConversation.removeLine()!
                nextState = .FailConvo
                externalState = .SpeakAngry
            }
        }
        
        currentState = nextState
        return externalState
    }
    
    private func conversationFinished(type: UDConversationType) -> Bool {
        guard let request = request else {
            return true
        }
        
        switch(type) {
        case .Initial:
            return request.initialConversation.finished
        case .Pass:
            return request.passConversation.finished
        case .Fail:
            return request.failConversation.finished
        }
    }
}
