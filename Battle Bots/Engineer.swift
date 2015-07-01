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
    
    
    var toolNode: SKSpriteNode
    var toolRotateSpeed: CGFloat = engineerToolRotateSpeed
    
    override init(team: Team, world: World) {
        
        self.toolNode = SKSpriteNode(imageNamed: "EngineerTool")
        self.toolNode.setScale(autosScale)
        
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
        self.toolRotateSpeed = engineerToolRotateSpeed
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
        self.toolNode.zPosition = 4
        
        self.bodyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: chassisNode.frame.width, height: chassisNode.frame.height))
        self.bodyNode.physicsBody?.affectedByGravity = false
        self.bodyNode.physicsBody?.categoryBitMask = physicsCategory.Auto.rawValue
        self.bodyNode.physicsBody?.collisionBitMask = autoCollisionBitMask
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
        self.bodyNode.addChild(toolNode)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        self.doIdleRotation()
    }
    
    func getActionPointToolTowardsPosition(point: CGPoint) -> SKAction {
        let actionRotate = getActionRotateNodeTowardsPoint(self.toolNode, self.world.convertPoint(point, toNode: self.toolNode.parent!), self.toolRotateSpeed)
        return actionRotate
    }
    
    func rotateToolTowardsPoint(point: CGPoint) {
        let actionRotate = self.getActionPointToolTowardsPosition(point)
        self.toolNode.runAction(actionRotate, withKey: keyRotate)
    }
    
    func rotateToolToAngle(angle: CGFloat, duration: NSTimeInterval) {
        if self.toolNode.actionForKey(keyRotate) == nil {
            let actionRotate = SKAction.rotateToAngle(angle, duration: duration)
            self.toolNode.runAction(actionRotate, withKey: keyRotate)
        }
    }
    
    func doIdleRotation() {
        if self.toolNode.actionForKey(keyRotate) == nil {
            if self.toolNode.zRotation <= 0 {
                self.rotateToolToAngle(CGFloat(M_PI_4), duration: 2)
            }
            else {
                self.rotateToolToAngle(CGFloat(-M_PI_4), duration: 4)
            }
        }
    }
    
    
    
}