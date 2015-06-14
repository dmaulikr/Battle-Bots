//
//  Artillery.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/10/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var artilleryNameCount: Int = 0

class Artillery: WeaponizedAuto {
    
    var rocketsPerReload: Int = rocketRocketsPerReload
    
    override init(team: Team, world: World) {
        
        super.init(team: team, world: world)
        
        self.turretNode = SKSpriteNode(imageNamed: "TurretRocket")
        self.turretNode!.setScale(autosScale)
        
        self.reloadTime = rocketReloadTime
        self.framesSinceFiring = rocketReloadTime
        
        self.fsm = FSM(_states: artilleryStates)
        
        artilleryNameCount += 1
        self.name! += "artillery\(artilleryNameCount)"
        
        self.type = .Artillery
        self.oreCost = artilleryOreCost
        self.health = artilleryHealth
        self.maxHealth = artilleryHealth
        self.energy = artilleryEnergy
        self.maxEnergy = artilleryEnergy
        self.baseSpeed = artilleryBaseSpeed
        self.baseRotateSpeed = artilleryBaseRotateSpeed
        self.sightRadius = artillerySightRadius
        self.turretRotateSpeed = artilleryTurretRotateSpeed
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode!.fillColor = sightNodeFillColor
        self.sightNode!.strokeColor = sightNodeStrokeColor
        
        self.chassisNode = SKSpriteNode(imageNamed: "HeavyChassis")
        self.chassisNode.setScale(autosScale)
        
        self.mobilityNode = SKSpriteNode(imageNamed: "HeavyWheels")
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
        
        let actionCreateAndFireRocket = SKAction.runBlock({
            let rocket = Rocket(turretNode: self.turretNode!, mechanism: self, world: self.world, targetLocation: point)
            self.world.addChild(rocket)
            rocket.fire()
        })
        let actionFireWithDelay = SKAction.repeatAction(SKAction.sequence([actionCreateAndFireRocket, SKAction.waitForDuration(0.5)]), count: self.rocketsPerReload)
        
        if self.actionForKey("firngRockets") == nil {
            self.runAction(actionFireWithDelay, withKey: "firingRockets")
        }
        
        
    }
}