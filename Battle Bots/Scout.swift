//
//  Scout.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var scoutNameCount: Int = 0

class Scout: Auto {
    
    var dishNode: SKSpriteNode
    
    override init(team: Team, world: World) {
        
        self.dishNode = SKSpriteNode(imageNamed: "DishSmall")
        self.dishNode.xScale = autosScale
        self.dishNode.yScale = autosScale
        
        super.init(team: team, world: world)
        
        self.fsm = FSM(_states: scoutStates)
        
        scoutNameCount += 1
        self.name! += "scout\(scoutNameCount)"
        
        self.type = .Scout
        self.health = scoutHealth
        self.maxHealth = scoutHealth
        self.energy = scoutEnergy
        self.maxEnergy = scoutEnergy
        self.baseSpeed = scoutBaseSpeed
        self.baseRotateSpeed = scoutBaseRotateSpeed
        self.sightRadius = scoutSightRadius
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode.fillColor = sightNodeFillColor
        self.sightNode.strokeColor = sightNodeStrokeColor
        
        self.chassisNode = SKSpriteNode(imageNamed: "Chassis")
        self.chassisNode.xScale = autosScale
        self.chassisNode.yScale = autosScale
        
        self.mobilityNode = SKSpriteNode(imageNamed: "Wheels")
        self.mobilityNode.xScale = autosScale
        self.mobilityNode.yScale = autosScale
        
        self.sightNode.zPosition = 1
        self.mobilityNode.zPosition = 2
        self.chassisNode.zPosition = 3
        self.dishNode.zPosition = 4
        
        self.bodyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: chassisNode.frame.width, height: chassisNode.frame.height))
        self.bodyNode.physicsBody?.affectedByGravity = false
        self.bodyNode.physicsBody?.categoryBitMask = physicsCategory.Auto.rawValue
        self.bodyNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.bodyNode.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Projectile.rawValue | physicsCategory.Structure.rawValue
        
        self.sightNode.physicsBody = SKPhysicsBody(circleOfRadius: self.sightRadius!)
        self.sightNode.physicsBody?.affectedByGravity = false
        self.sightNode.physicsBody?.categoryBitMask = physicsCategory.Sight.rawValue
        self.sightNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.sightNode.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Structure.rawValue | physicsCategory.Projectile.rawValue
        
        
        self.addChild(self.bodyNode)
        self.addChild(self.sightNode)
        self.addChild(self.healthBar)
        self.bodyNode.addChild(mobilityNode)
        self.bodyNode.addChild(chassisNode)
        self.bodyNode.addChild(dishNode)
        
        self.startDishRotation()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        if self.energy <= 0 {
            self.stopDishRotation()
        }
    }
    
    func startDishRotation() {
        if self.dishNode.actionForKey(keyRotateDish) == nil {
            self.dishNode.runAction(actionRotateDish, withKey: keyRotateDish)
        }
    }
    
    func stopDishRotation() {
        if self.dishNode.actionForKey(keyRotateDish) != nil {
            self.dishNode.removeActionForKey(keyRotateDish)
        }
    }
    
    func rotateDishTowards(point: CGPoint) {
        rotateNodeTowardsPoint(self.dishNode, self.world.convertPoint(point, toNode: self.dishNode.parent!), 1)
    }
    
}