//
//  Engineer.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/14/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var engineerNameCount: Int = 0

class Engineer: Auto {
    
    override init(team: Team, world: World) {

        
        super.init(team: team, world: world)
        
        self.fsm = FSM(_states: engineerStates)
        
        engineerNameCount += 1
        self.name! += "engineer\(engineerNameCount)"
        
        self.type = .Engineer
        self.oreCost = engineerOreCost
        self.health = engineerHealth
        self.maxHealth = engineerHealth
        self.energy = engineerEnergy
        self.maxEnergy = engineerEnergy
        self.baseSpeed = engineerBaseSpeed
        self.baseRotateSpeed = engineerBaseRotateSpeed
        self.sightRadius = engineerSightRadius
        
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

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
    }
    
    
}