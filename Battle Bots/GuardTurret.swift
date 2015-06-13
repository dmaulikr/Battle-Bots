//
//  GuardTurret.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/7/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class GuardTurret: Structure {
    
//    override var healthBar: HealthBar {
//        get{return HealthBar(type: .GuardTurret)}
//        set{self.healthBar = HealthBar(type: .GuardTurret)}
//    }
    
    var layer_1: SKSpriteNode?
    var layer_2: SKSpriteNode?
    var turretNode: SKSpriteNode?
    
    var framesSinceFiring: Int?
    var reloadTime: Int?
    
    override init(team: Team, world: World) {
        super.init(team: team, world: world)
        
        self.healthBar = HealthBar(type: .GuardTurret)
        self.addChild(healthBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        self.framesSinceFiring! += 1
    }
    
    
    override func takeDamage(amount: CGFloat) {
        super.takeDamage(amount)
        self.layer_1!.runAction(actionTakeDamage)
        self.layer_2!.runAction(actionTakeDamage)
        self.turretNode!.runAction(actionTakeDamage)
    }
    
    func targetPosition(point: CGPoint) {
        if self.actionForKey("RotatingTowardsEnemy") == nil {
            let turretTurnSpeed: CGFloat = 4
            let actionRotateTowardsEnemy = SKAction.runBlock({rotateNodeTowardsPoint(self.turretNode!, self.world.convertPoint(point, toNode: self.turretNode!.parent!), turretTurnSpeed)})
            self.runAction(actionRotateTowardsEnemy, withKey: "RotatingTowardsEnemy")
        }
    }
    
    func fireAtPosition(point: CGPoint) {
        self.framesSinceFiring = 0
    }
    
    func attack(mechanism: Mechanism) {
        if self.framesSinceFiring >= self.reloadTime {
            self.targetPosition(mechanism.position)
            self.fireAtPosition(mechanism.position)
        }
    }
    
}
