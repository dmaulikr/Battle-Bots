//
//  WeaponizedAuto.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/5/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class WeaponizedAuto: Auto {
    
    var turretNode: SKSpriteNode?
    var framesSinceFiring: Int?
    var reloadTime: Int?
    var turretRotateSpeed: CGFloat?
    
    
    override func update() {
        super.update()
        self.framesSinceFiring! += 1
        
    }
    
    func getActionTargetPosition(point: CGPoint) -> SKAction {
        let actionRotate = getActionRotateNodeTowardsPoint(self.turretNode!, self.world.convertPoint(point, toNode: self.turretNode!.parent!), self.turretRotateSpeed!)
        return actionRotate
//        if self.actionForKey("RotatingTowardsEnemy") == nil {
//            let actionRotateTowardsEnemy = SKAction.runBlock({rotateNodeTowardsPoint(self.turretNode!, self.world.convertPoint(point, toNode: self.turretNode!.parent!), self.turretRotateSpeed!)})
//            self.runAction(actionRotateTowardsEnemy, withKey: "RotatingTowardsEnemy")
//        }
    }
    
    func fireAtPosition(point: CGPoint) {
        self.framesSinceFiring = 0
    }
    
    func attack(mechanism: Mechanism) {

        if self.framesSinceFiring >= self.reloadTime {
            let keyFiring = "firing"
            if self.actionForKey(keyFiring) == nil {
                let actionTargetAndFire = SKAction.runBlock({self.turretNode!.runAction(self.getActionTargetPosition(mechanism.position), completion: {if self.framesSinceFiring >= self.reloadTime {self.fireAtPosition(mechanism.position)}})})
                //let actionTarget = SKAction.runBlock([self.getActionTargetPosition(mechanism.position), SKAction.runBlock({self.fireAtPosition(mechanism.position)})])
                self.runAction(actionTargetAndFire, withKey: keyFiring)
            }
        }
    }
    
}