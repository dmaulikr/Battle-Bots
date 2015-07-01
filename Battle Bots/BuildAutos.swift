//
//  BuildAutos.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/14/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class BuildAutos: State {
    
    override var type: stateType? {
        get {return .BuildAutos}
        set {self.type = .BuildAutos}
    }
    
    override var priority: Int {
        get {return buildAutosPriority}
        set {self.priority = buildAutosPriority}
    }
    
    var autoTypeToBuild: autoType? = nil
    var autoOreCost: CGFloat? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.autoTypeToBuild = nil
    }
    
    override func conditionsMet() -> Bool {
        
        if determineWhichAutoToBuild() {
            let oreCost = getOreCostOfAutoType(self.autoTypeToBuild!)
            if self.teamHasOreAmountGreaterThanOrEqualTo(oreCost) == false {
                return false
            }
            else {
                return true
            }
        }
        return false
        
    }
    
    override func canBeActive() -> Bool {
        if target?.mechType == .Structure {
            return conditionsMet()
        }
        else {
            return false
        }
    }
    
    override func run() {
        if self.autoTypeToBuild == nil {
            self.determineWhichAutoToBuild()
        }
        else if let HQ = self.target as? Headquarters {
            HQ.buildAuto(self.autoTypeToBuild!)
        }
    }
    
    func determineWhichAutoToBuild() -> Bool {
        //TODO: Refine to make more intelligent

        let autos = self.target!.team.autosOfType
        for i in 0...50 {
            if autos[autoType.Miner] == nil || autos[autoType.Miner]?.count <= i {
                self.autoTypeToBuild = .Miner
                return true
            }
            else if autos[autoType.Engineer] == nil || autos[autoType.Engineer]?.count <= i {
                self.autoTypeToBuild = .Engineer
                return true
            }
            else if autos[autoType.LightArmor] == nil || autos[autoType.LightArmor]?.count <= i {
                self.autoTypeToBuild = .LightArmor
                return true
            }
            else if autos[autoType.Scout] == nil || autos[autoType.Scout]?.count <= i {
                self.autoTypeToBuild = .Scout
                return true
            }
            else if autos[autoType.MachineGunner] == nil || autos[autoType.MachineGunner]?.count <= i {
                self.autoTypeToBuild = .MachineGunner
                return true
            }
            else if autos[autoType.Medic] == nil || autos[autoType.Medic]?.count <= i {
                self.autoTypeToBuild = .Medic
                return true
            }
            else if autos[autoType.ScatterShot] == nil || autos[autoType.ScatterShot]?.count <= i {
                self.autoTypeToBuild = .ScatterShot
                return true
            }
            else if autos[autoType.Artillery] == nil || autos[autoType.Artillery]?.count <= i {
                self.autoTypeToBuild = .Artillery
                return true
            }
        }
        
        return false
    }

}