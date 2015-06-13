//
//  Team.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/31/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Team {
    var name: String
    var mechanisms = [Mechanism]()
    var structures = [Structure]()
    var chargingStations = [ChargingStation]()
    var repairStations = [RepairStation]()
    var headquarters = [Headquarters]()
    var guardTurrets = [GuardTurret]()
    var autos = [Auto]()
    var knownEnemyStructures = [Structure]()
    var knownEnemyAutos = [Auto]()
    var knownOreDeposits = [OreDeposit]()
    
    init(name: String) {
        self.name = name
    }
    
    init() {
        self.name = "Default"
    }
    
    func add(mechanism: Mechanism) {
        self.mechanisms.append(mechanism)
        if mechanism.mechType == .Structure {
            let structure = mechanism as! Structure
            self.structures.append(structure)
            switch structure.type {
            case .ChargingStation:
                self.chargingStations.append(structure as! ChargingStation)
            case .RepairStation:
                self.repairStations.append(structure as! RepairStation)
            case .Headquarters:
                self.headquarters.append(structure as! Headquarters)
            case .BulletGuardTurret:
                self.guardTurrets.append(structure as! GuardTurret)
            default:
                fatalError("ERROR: Unkown structure type \(structure.type)")
            }
        }
        if mechanism.mechType == .Auto {
            let auto = mechanism as! Auto
            self.autos.append(auto)
        }
    }
    
    func remove(mechanism: Mechanism) {
        if contains(self.mechanisms, mechanism) {
            self.mechanisms.removeAtIndex(find(self.mechanisms, mechanism)!)
        }
        if mechanism.mechType == .Structure {
            let structure = mechanism as! Structure
            if contains(self.structures, structure) {
                self.structures.removeAtIndex(find(self.structures, structure)!)
            }
        }
        if mechanism.mechType == .Auto {
            let auto = mechanism as! Auto
            if contains(self.autos, auto) {
                self.autos.removeAtIndex(find(self.autos, auto)!)
            }
        }
    }
    
    func addEnemyMechanism(mechanism: Mechanism) {
        if mechanism.team.name != self.name && mechanism.health > 0{
            switch mechanism.mechType! {
            case .Structure:
                if contains(self.knownEnemyStructures, mechanism as! Structure) == false {
                    self.knownEnemyStructures.append(mechanism as! Structure)
                }
            case .Auto:
                if contains(self.knownEnemyAutos, mechanism as! Auto) == false {
                    self.knownEnemyAutos.append(mechanism as! Auto)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'addEnemyMechanism()' for the mechanism '\(mechanism.name)'")
            }
        }
    }
    
    func removeEnemyMechanism(mechanism: Mechanism) {
        if mechanism.team.name != self.name {
            
            switch mechanism.mechType! {
            case .Structure:
                if contains(self.knownEnemyStructures, mechanism as! Structure) {
                    self.knownEnemyStructures.removeAtIndex(find(self.knownEnemyStructures,mechanism as! Structure)!)
                }
            case .Auto:
                if contains(self.knownEnemyAutos, mechanism as! Auto) {
                    self.knownEnemyAutos.removeAtIndex(find(self.knownEnemyAutos,mechanism as! Auto)!)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'addEnemyMechanism()' for the mechanism '\(mechanism.name)'")
            }
        }
    }
    
    func addOreDeposit(oreDeposit: OreDeposit) {
        if contains(self.knownOreDeposits, oreDeposit) == false {
            self.knownOreDeposits.append(oreDeposit)
        }
    }
    
    func removeOreDeposit(oreDeposit: OreDeposit) {
        if contains(self.knownOreDeposits, oreDeposit) {
            self.knownOreDeposits.removeAtIndex(find(self.knownOreDeposits, oreDeposit)!)
        }
    }
    
    
}