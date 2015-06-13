//
//  Recharge.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Recharge: State {
    override var type: stateType? {
        get {return .Recharge}
        set {self.type = .Recharge}
    }
    
    override var priority: Int {
        get {return rechargePriority}
        set {self.priority = rechargePriority}
    }
    
    var closestChargingStation: ChargingStation? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestChargingStation = nil
    }
    
    override func conditionsMet() -> Bool {
        if self.energyLessThan(0.90) == false {
            return false
        }
        else if self.touchingStructureOfType(.ChargingStation) == false {
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
            self.findClosestChargingStation()
        }
        else if let auto = self.target as? Auto {
            if auto.energy! / auto.maxEnergy! < 1.0 {
                auto.recharge(self.closestChargingStation!.chargeAmount)
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
