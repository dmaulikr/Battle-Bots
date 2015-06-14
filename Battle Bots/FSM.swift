//
//  FSM.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var FSMCount: Int = 1

class FSM {
    //The Finite State Machine that handles all the AI of the mechanisms. It choses which state to run depending on the mechanism's condition.
    
    var name: String?
    
    var states = [State]()
    var potentialStates = [State]()
    var target: Mechanism? = nil
    var currentState: State? = nil
    
    var isActive: Bool = true
    
    init(_states: [stateType]) {
        if contains(_states, .Wander) {
            self.states.append(Wander())
        }
        if contains(_states, .Guard) {
            self.states.append(Guard())
        }
        if contains(_states, .NeedRepair) {
            self.states.append(NeedRepair())
        }
        if contains(_states, .Repairing) {
            self.states.append(Repairing())
        }
        if contains(_states, .Attack) {
            self.states.append(Attack())
        }
        if contains(_states, .NeedCharge) {
            self.states.append(NeedCharge())
        }
        if contains(_states, .Recharge) {
            self.states.append(Recharge())
        }
        if contains(_states, .MoveToKnownEnemy) {
            self.states.append(MoveToKnownEnemy())
        }
        if contains(_states, .MoveToWeakUnit) {
            self.states.append(MoveToWeakUnit())
        }
        if contains(_states, .RepairUnit) {
            self.states.append(RepairUnit())
        }
        if contains(_states, .MoveToHQ) {
            self.states.append(MoveToHQ())
        }
        if contains(_states, .MoveToOreDeposit) {
            self.states.append(MoveToOreDeposit())
        }
        if contains(_states, .MineOre) {
            self.states.append(MineOre())
        }
        if contains(_states, .MoveToDeliverOre) {
            self.states.append(MoveToDeliverOre())
        }
        if contains(_states, .DeliverOre) {
            self.states.append(DeliverOre())
        }
        if contains(_states, .BuildAutos) {
            self.states.append(BuildAutos())
        }
        
        self.name = "FSM\(FSMCount)"
        FSMCount += 1
    }
    
    init() {
        self.states = []
        self.name = "Default FSM"
    }
    
    func addStates(_states: [State]) {
        self.states += _states
        for _state in self.states {
            _state.setNewTarget(self.target!)
        }
    }
    
//    func removeStates(newStates: [State]) {
//        for _state in newStates {
//            if contains(self.states, _state) {
//                self.states.removeAtIndex(find(self.states, _state)!)
//            }
//        }
//    }
    
    func setNewTarget(target: Mechanism) {
        self.target = target
        for _state in self.states {
            _state.setNewTarget(self.target!)
        }
    }
    
    func pause() {
        println("Pausing")
        self.isActive = false
        if self.currentState != nil {
            self.currentState!.deactivate()
        }
    }
    
    func resume() {
        println("Resuming")
        self.isActive = true
        self.currentState!.activate()
    }
    
    func sortStatesByPriority(_states:[State]) -> [State] {
        //Sort the states in order of priority
        var sortedStates = _states
        sortedStates.sort { $0.priority < $1.priority }
        
//        for i in 0...(sortedStates.count-1) {
//            println("\(i+1). \(sortedStates[i])")
//        }
        
        return sortedStates
    }
    
    func switchToState(state: State) {
        if self.currentState != nil {
            self.currentState!.deactivate()
        }
        self.currentState = state
        if self.currentState != nil {
            self.currentState!.activate()
        }
    }
    
    func switchToHighestPriorityState() {
        if self.states.isEmpty == false {
            self.potentialStates = []
            for _state in self.states {
                if _state.canBeActive() {
                    self.potentialStates.append(_state)
                }
                else if _state.active {
                    _state.deactivate()
                }
            }
            
            if self.potentialStates.isEmpty == false {
                self.potentialStates = sortStatesByPriority(self.potentialStates)
                let potentialState = self.potentialStates[0]
                if self.currentState != nil {
                    if potentialState.type != self.currentState!.type {
                        self.switchToState(potentialState)
                    }
                }
                else {
                    self.switchToState(potentialState)
                    
                }
            }
        }
    }
    
    func update() {
        if self.isActive && self.target != nil {
            switchToHighestPriorityState()
            if self.currentState != nil {
                self.currentState?.setNewTarget(self.target!)
                self.currentState!.run()
            }
        }
    }
    
    
}