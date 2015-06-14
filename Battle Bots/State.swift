//
//  State.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var stateNameCount = 1

class State {
    var name: String
    var type: stateType? = nil
    var target: Mechanism? = nil
    var priority: Int = defaultPriority
    var active: Bool = false
    var conditions: Any = []
    
    init() {
        self.name = "State#\(stateNameCount)"
        stateNameCount += 1
    }
    
    func setNewTarget(target: Mechanism) {
        self.target = target
    }
    
    func activate() {
        self.active = true
    }
    
    func deactivate() {
        self.active = false
    }
    
    func conditionsMet() -> Bool {
        //Put the specific conditions the mech needs to be in this state
        return false
    }
    
    func canBeActive() -> Bool {
        //When the mechanism could be in this state
        return false
    }
    
    func run() {
        //Customize for each state type
    }
    
    //Methods to test different conditions
    func healthGreaterThan(percentage: CGFloat) -> Bool {
        if self.target != nil {
            if round(self.target!.health)/round(self.target!.maxHealth) > percentage {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func healthLessThan(percentage: CGFloat) -> Bool {
        if self.target != nil {
            if self.target!.health/self.target!.maxHealth < percentage {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func teamMemberIsWeak(healthThreshold: CGFloat) -> Bool {
        for mechanism in self.target!.team.mechanisms {
            if mechanism.health / mechanism.maxHealth <= healthThreshold && mechanism.health > 0 {
                if mechanism != self.target {
                    return true
                }
            }
        }
        return false
    }
    
    func teamMemberIsWeakAndAcceptsGuards(healthThreshold:CGFloat) -> Bool {
        for mechanism in self.target!.team.mechanisms {
            if mechanism.health / mechanism.maxHealth <= healthThreshold {
                if mechanism.guards.count < mechanism.maxGuardPositions || contains(mechanism.guards, self.target!) {
                    return true
                }
            }
        }
        return false
    }
    
    func touchingStructureOfType(type: structureType) -> Bool {
        for mechanism in self.target!.structuresInContactWith {
            let structure = mechanism as Structure
            if structure.type == type {
                return true
            }
        }
        return false
    }
    
    func touchingOreDeposit() -> Bool {
        if let miner = self.target as? Miner {
            if miner.oreDepositsInContactWith.isEmpty == false {
                return true
            }
        }
        return false
    }
    
    func canCarryMoreOre() -> Bool {
        if let miner = self.target as? Miner {
            if miner.oreAmount < miner.oreMaxCapacity {
                return true
            }
        }
        return false
    }
    
    func hasOre() -> Bool {
        if let miner = self.target as? Miner {
            if miner.oreAmount > 0 {
                return true
            }
        }
        return false
    }
    
    func touchingWeakMechanism(healthThreshold: CGFloat) -> Bool {
        let mechanismsInContactWith: [Mechanism] = self.target!.structuresInContactWith as [Mechanism] + self.target!.autosInContactWith as [Mechanism]
        for _mechanism in mechanismsInContactWith {
            let mechanism = _mechanism as Mechanism
            if mechanism.health / mechanism.maxHealth < healthThreshold {
                return true
            }
        }
        return false
    }
    
    func touchingMechanismOfType(type: mechanismType) -> Bool {
        let mechanismsInContactWith: [Mechanism] = self.target!.structuresInContactWith as [Mechanism] + self.target!.autosInContactWith as [Mechanism]
        for _mechanism in mechanismsInContactWith {
            let mechanism = _mechanism as Mechanism
            if mechanism.mechType == type {
                return true
            }
        }
        return false
    }
    
    func teamHasStructureOfType(type: structureType) -> Bool {
        if self.target?.team.structures.isEmpty == false {
            for structure in self.target!.team.structures {
                if (structure as Structure).type == type {
                    return true
                }
            }
        }
        return false
    }
    
    func teamKnowsEnemyStructure() -> Bool {
        if self.target!.team.knownEnemyAutos.isEmpty == false || self.target!.team.knownEnemyStructures.isEmpty == false {
            return true
        }
        return false
    }
    
    func teamKnowsOreDeposit() -> Bool {
        if self.target?.team.knownOreDeposits.isEmpty == false {
            return true
        }
        return false
    }
    
    func energyLessThan(percentage: CGFloat) -> Bool {
        if self.target != nil {
            if let auto = self.target as? Auto {
                if auto.energy!/auto.maxEnergy! < percentage {
                    return true
                }
                else {
                    
                    return false
                }
            }
            return false
        }
        else {
            return false
        }
    }
    
    func canSeeEnemyMechanismOfType(type: mechanismType) -> Bool {
        switch type {
        case .Structure:
            if self.target?.enemyStructuresInSight.isEmpty == false {
                return true
            }
            else {
                return false
            }
        case .Auto:
            if self.target?.enemyAutosInSight.isEmpty == false {
                return true
                
            }
            else {
                return false
            }
        default:
            fatalError("Unknown type \(type) in canSeeEnemyMechanismOfType")
        }
    }
    
    func teamHasOreAmountGreaterThanOrEqualTo(amount: CGFloat) -> Bool {
        if self.target?.team.oreAmount >= amount {
            return true
        }
        return false
    }
    
}