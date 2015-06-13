//
//  Repairing.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/3/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Repairing: State {
    override var type: stateType? {
        get {return .Repairing}
        set {self.type = .Repairing}
    }
    
    override var priority: Int {
        get {return repairingPriority}
        set {self.priority = repairingPriority}
    }
    
    var closestRepairStation: RepairStation? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestRepairStation = nil
    }
    
    override func conditionsMet() -> Bool {
        if self.healthLessThan(1.0) == false {
            return false
        }
        else if self.touchingStructureOfType(.RepairStation) == false {
            return false
        }
        else {
            return true
        }
    }
    
    override func canBeActive() -> Bool {
        if target?.mechType == .Auto {
            return conditionsMet()
        }
        else {
            return false
        }
    }
    
    override func run() {
        if self.closestRepairStation == nil {
            self.findClosestRepairStation()
        }
        else if self.target!.health / self.target!.maxHealth < 1.0 {
            if let auto = self.target as? Auto {
                auto.repair(self.closestRepairStation!.repairAmount)
            }
        }
    }
    
    func findClosestRepairStation() -> Bool {
        if self.target?.team.repairStations.isEmpty == false {
            if self.target?.team.repairStations.count == 1 {
                self.closestRepairStation = self.target?.team.repairStations[0]
                return true
            }
            else {
                var distances = [CGFloat]()
                for repairStation in self.target!.team.repairStations {
                    distances.append(getDistance(self.target!.position, repairStation.position))
                }
                self.closestRepairStation = self.target?.team.repairStations[find(distances,minElement(distances))!]
                return true
            }
        }
        else {
            return false
        }
    }

    
    
    
    
    
    
    
    
    
    
}