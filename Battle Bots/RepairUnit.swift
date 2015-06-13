//
//  RepairUnit.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/7/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class RepairUnit: State {
    
    override var type: stateType? {
        get {return .RepairUnit}
        set {self.type = .RepairUnit}
    }
    
    override var priority: Int {
        get {return repairUnitPriority}
        set {self.priority = repairUnitPriority}
    }
    
    var asset: Mechanism?
    var assetHealthThreshold: CGFloat = 1.0
    
    override func deactivate() {
        super.deactivate()
        self.asset = nil
    }
    
    override func conditionsMet() -> Bool {
        if self.touchingWeakMechanism(self.assetHealthThreshold) == false {
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
        if self.asset == nil {
            self.getNewAsset()
        }
        else if self.asset!.health / self.asset!.maxHealth < assetHealthThreshold {
            if let medic = self.target as? Medic {
                medic.showRepairing()
                self.asset?.repair(medic.repairAmount)
            }
        }
    }
    
    func getNewAsset() -> Bool {
        let mechanismsInContactWith: [Mechanism] = self.target!.structuresInContactWith as [Mechanism] + self.target!.autosInContactWith as [Mechanism]
        var healthPercentages = [CGFloat]()
        for _mechanism in mechanismsInContactWith {
            let mechanism = _mechanism as Mechanism
            let mechHealthPercentage = mechanism.health/mechanism.maxHealth
            healthPercentages.append(mechHealthPercentage)
            
        }
        if healthPercentages.isEmpty == false {
            self.asset = mechanismsInContactWith[find(healthPercentages, minElement(healthPercentages))!]
            return true
        }
        else {
            return false
        }
    }
    
    
    
    
    
}