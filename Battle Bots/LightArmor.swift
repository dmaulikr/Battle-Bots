//
//  LightArmor.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/4/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var lightArmorNameCount: Int = 0

class LightArmor: WeaponizedAuto {
    
    override init(team: Team, world: World) {
        
        super.init(team: team, world: world)
        
        self.turretNode = SKSpriteNode(imageNamed: "TurretOneBarrel")
        self.turretNode!.setScale(autosScale)
        
        self.reloadTime = mediumBulletReloadTime
        self.framesSinceFiring = mediumBulletReloadTime
        
        self.fsm = FSM(_states: lightArmorStates)
        
        lightArmorNameCount += 1
        self.name! += "lightArmor\(lightArmorNameCount)"
        
        self.type = .LightArmor
        self.oreCost = lightArmorOreCost
        self.health = lightArmorHealth
        self.maxHealth = lightArmorHealth
        self.energy = lightArmorEnergy
        self.maxEnergy = lightArmorEnergy
        self.baseSpeed = lightArmorBaseSpeed
        self.baseRotateSpeed = lightArmorBaseRotateSpeed
        self.sightRadius = lightArmorSightRadius
        self.turretRotateSpeed = lightArmorTurretRotateSpeed
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode!.fillColor = sightNodeFillColor
        self.sightNode!.strokeColor = sightNodeStrokeColor
        
        self.chassisNode = SKSpriteNode(imageNamed: "Chassis")
        self.chassisNode.setScale(autosScale)
        
        self.mobilityNode = SKSpriteNode(imageNamed: "Wheels")
        self.mobilityNode.setScale(autosScale)
        
        self.sightNode!.zPosition = 1
        self.mobilityNode.zPosition = 2
        self.chassisNode.zPosition = 3
        self.turretNode!.zPosition = 4
        
        self.bodyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: chassisNode.frame.width, height: chassisNode.frame.height))
        self.bodyNode.physicsBody?.affectedByGravity = false
        self.bodyNode.physicsBody?.categoryBitMask = physicsCategory.Auto.rawValue
        self.bodyNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.bodyNode.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Projectile.rawValue | physicsCategory.Structure.rawValue
        
        self.sightNode!.physicsBody = SKPhysicsBody(circleOfRadius: self.sightRadius!)
        self.sightNode!.physicsBody?.affectedByGravity = false
        self.sightNode!.physicsBody?.categoryBitMask = physicsCategory.Sight.rawValue
        self.sightNode!.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.sightNode!.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Structure.rawValue | physicsCategory.Projectile.rawValue | physicsCategory.Ore.rawValue
        
        
        self.addChild(self.bodyNode)
        self.addChild(self.sightNode!)
        self.addChild(self.healthBar)
        self.bodyNode.addChild(mobilityNode)
        self.bodyNode.addChild(chassisNode)
        self.bodyNode.addChild(turretNode!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
    }
    
    override func fireAtPosition(point: CGPoint) {
        super.fireAtPosition(point)
        let bullet = MediumBullet(turretNode: self.turretNode!, mechanism: self, world: self.world)
        self.world.addChild(bullet)
        bullet.fire()
    }
    
    
}