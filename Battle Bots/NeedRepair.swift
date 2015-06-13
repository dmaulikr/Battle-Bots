//
//  NeedRepair.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/3/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class NeedRepair: State {
    
    override var type: stateType? {
        get {return .NeedRepair}
        set {self.type = .NeedRepair}
    }
    
    override var priority: Int {
        get {return needRepairPriority}
        set {self.priority = needRepairPriority}
    }
    
    let healthPercentThreshold: CGFloat = 0.5
    var closestRepairStation: RepairStation? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestRepairStation = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.healthLessThan(self.healthPercentThreshold) == false {
            return false
        }
        else if self.teamHasStructureOfType(.RepairStation) == false {
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
            if let auto = self.target as? Auto {
                if findClosestRepairStation() {
                    auto.moveTo(self.closestRepairStation!.position, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
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