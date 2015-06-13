//
//  NeedCharge.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class NeedCharge: State {
    
    override var type: stateType? {
        get {return .NeedCharge}
        set {self.type = .NeedCharge}
    }
    
    override var priority: Int {
        get {return needChargePriority}
        set {self.priority = needChargePriority}
    }
    
    let energyPercentThreshold: CGFloat = 0.25
    var closestChargingStation: ChargingStation? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestChargingStation = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.energyLessThan(self.energyPercentThreshold) == false {
            return false
        }
        else if self.teamHasStructureOfType(.ChargingStation) == false {
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
        if self.closestChargingStation == nil {
            if let auto = self.target as? Auto {
                if findClosestChargingStation() {
                    auto.moveTo(self.closestChargingStation!.position, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
            }
        }
    }
    
    func findClosestChargingStation() -> Bool {
        if self.target?.team.chargingStations.isEmpty == false {
            if self.target?.team.chargingStations.count == 1 {
                self.closestChargingStation = self.target?.team.chargingStations[0]
                return true
            }
            else {
                var distances = [CGFloat]()
                for chargingStation in self.target!.team.chargingStations {
                    distances.append(getDistance(self.target!.position, chargingStation.position))
                }
                self.closestChargingStation = self.target?.team.chargingStations[find(distances,minElement(distances))!]
                return true
            }
        }
        else {
            return false
        }
    }
    
}