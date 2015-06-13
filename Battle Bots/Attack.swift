//
//  Attacking.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/4/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Attack: State {
    
    override var type: stateType? {
        get {return .Attack}
        set {self.type = .Attack}
    }
    
    override var priority: Int {
        get {return attackingPriority}
        set {self.priority = attackingPriority}
    }
    
    var enemyTarget: Mechanism? = nil
    var enemyTargetPosition: CGPoint?
    
    
    override func deactivate() {
        super.deactivate()
        self.enemyTarget = nil
        if let weaponizedAuto = self.target as? WeaponizedAuto {
            rotateNodeTowardsPoint(weaponizedAuto.turretNode!, CGPoint(x: 0, y: 5), 0.4)
        }
        else if let guardTurrt = self.target as? GuardTurret {
            rotateNodeTowardsPoint(guardTurrt.turretNode!, CGPoint(x: 0, y: 5), 0.4)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.canSeeEnemyMechanismOfType(.Structure) == false && self.canSeeEnemyMechanismOfType(.Auto) == false{
            return false
        }
        else {
            return true
        }
    }
    
    override func canBeActive() -> Bool {
        return conditionsMet()
    }
    
    override func run() {
        if self.enemyTarget == nil {
            self.findClosestEnemy()
            self.enemyTargetPosition = self.enemyTarget?.position
        }
        else if enemyStillInSight() == false{
            self.enemyTarget = nil
        }
        else if self.enemyTarget?.health > 0 {
            if let weaponizedArmor = self.target as? WeaponizedAuto {
                if getDistance(self.enemyTargetPosition!, self.enemyTarget!.position) >= 5 {
                    self.enemyTargetPosition = self.enemyTarget?.position
                    //weaponizedArmor.targetPosition(self.enemyTargetPosition!)
                }
                weaponizedArmor.attack(self.enemyTarget!)
            }
            else if let guardTurret = self.target as? GuardTurret {
                if getDistance(self.enemyTargetPosition!, self.enemyTarget!.position) >= 5 {
                    self.enemyTargetPosition = self.enemyTarget?.position
                    guardTurret.targetPosition(self.enemyTargetPosition!)
                }
                guardTurret.attack(self.enemyTarget!)
            }
        }
    }
    
    func findClosestEnemy() -> Bool {
        
        var enemiesInSight: [Mechanism] = self.target!.enemyAutosInSight as [Mechanism] + self.target!.enemyStructuresInSight as [Mechanism]
        
        if enemiesInSight.isEmpty == false {
            
            var distances = [CGFloat]()
            for enemy in enemiesInSight {
                distances.append(getDistance(self.target!.position, enemy.position))
            }
            self.enemyTarget = enemiesInSight[find(distances,minElement(distances))!]
            return true
        }
        else {
            return false
        }
    }
    
    func enemyStillInSight() -> Bool {
        if self.enemyTarget != nil {
            switch self.enemyTarget!.mechType! {
            case .Structure:
                if contains(self.target!.enemyStructuresInSight, (self.enemyTarget as? Structure)!) == false {
                    return false
                }
                else{
                    return true
                }
            case .Auto:
                if contains(self.target!.enemyAutosInSight, (self.enemyTarget as? Auto)!) == false {
                    return false
                }
                else {
                    return true
                }
            default:
                fatalError("ERROR: Unknown mechType \(self.enemyTarget?.mechType) in enemyStillInSight()")
                
            }
        }
        else {
            return false
        }
    }

    
    
    
    
    
}