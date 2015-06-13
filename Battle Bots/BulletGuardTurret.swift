//
//  BulletGuardTurret.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/7/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//


import Foundation
import SpriteKit

var bulletGuardTurretNameCount: Int = 0

class BulletGuardTurret: GuardTurret {
    
    override var type: structureType {
        get{return .BulletGuardTurret}
        set{self.type = .BulletGuardTurret}
    }
    
    override init(team: Team, world: World) {
        super.init(team: team, world: world)
        
        self.layer_1 = SKSpriteNode(imageNamed: "Guard_Turret_1")
        self.layer_2 = SKSpriteNode(imageNamed: "Guard_Turret_2")
        self.turretNode = SKSpriteNode(imageNamed: "Turret_Bullets")
        
        self.reloadTime = smallBulletReloadTime
        self.framesSinceFiring = smallBulletReloadTime
        
        bulletGuardTurretNameCount += 1
        self.name! += "bulletGuardTurret\(bulletGuardTurretNameCount)"
        
        self.fsm = FSM(_states: bulletGuardTurretStates)
        
        layer_1!.setScale(structuresScale)
        layer_2!.setScale(structuresScale)
        turretNode!.setScale(structuresScale)
        
        layer_1!.zPosition = 0
        layer_2!.zPosition = 10
        turretNode!.zPosition = 11
        
        buildingNode.addChild(layer_1!)
        buildingNode.addChild(layer_2!)
        buildingNode.addChild(turretNode!)
        
        self.health = bulletGuardTurretHealth
        self.maxHealth = bulletGuardTurretHealth
        self.sightRadius = bulletGuardTurretSightRadius
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode!.fillColor = sightNodeFillColor
        self.sightNode!.strokeColor = sightNodeStrokeColor
        
        self.addChild(sightNode!)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.turretNode!.frame.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = physicsCategory.Structure.rawValue
        self.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Projectile.rawValue
        
        self.sightNode!.physicsBody = SKPhysicsBody(circleOfRadius: self.sightRadius!)
        self.sightNode!.physicsBody?.affectedByGravity = false
        self.sightNode!.physicsBody?.categoryBitMask = physicsCategory.Sight.rawValue
        self.sightNode!.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.sightNode!.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Structure.rawValue | physicsCategory.Projectile.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func takeDamage(amount: CGFloat) {
        super.takeDamage(amount)
    }
    
    override func update() {
        super.update()
    }
    
    override func fireAtPosition(point: CGPoint) {
        super.fireAtPosition(point)
        let bullet = SmallBullet(turretNode: self.turretNode!, mechanism: self, world: self.world)
        self.world.addChild(bullet)
        bullet.fire()
    }
    
    
}