//
//  Medic.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var medicNameCount: Int = 0

class Medic: Auto {
    
    var repairAmount = medicRepairAmount
    
    var crossNode: SKSpriteNode
    
    override init(team: Team, world: World) {
        
        self.crossNode = SKSpriteNode(imageNamed: "MedicCross")
        self.crossNode.setScale(autosScale)
        
        super.init(team: team, world: world)
        
        self.fsm = FSM(_states: medicStates)
        
        medicNameCount += 1
        self.name! += "medic\(medicNameCount)"
        
        self.type = .Medic
        self.health = medicHealth
        self.maxHealth = medicHealth
        self.energy = medicEnergy
        self.maxEnergy = medicEnergy
        self.baseSpeed = medicBaseSpeed
        self.baseRotateSpeed = medicBaseRotateSpeed
        self.sightRadius = medicSightRadius
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode.fillColor = sightNodeFillColor
        self.sightNode.strokeColor = sightNodeStrokeColor
        
        self.chassisNode = SKSpriteNode(imageNamed: "Chassis")
        self.chassisNode.setScale(autosScale)
        
        self.mobilityNode = SKSpriteNode(imageNamed: "Wheels")
        self.mobilityNode.setScale(autosScale)
        
        self.sightNode.zPosition = 1
        self.mobilityNode.zPosition = 2
        self.chassisNode.zPosition = 3
        self.crossNode.zPosition = 4
        
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
        self.bodyNode.addChild(crossNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
    }
    
    override func loseEnergy() {
        if self.crossNode.actionForKey("showingRepair") != nil {
            self.energy! -= 0.05
        }
        super.loseEnergy()
    }
    
    func showRepairing() {
        if self.crossNode.actionForKey("showRepairing") == nil {
            let actionShowRepairing = SKAction.sequence([SKAction.scaleBy(1.1, duration: repairDuration/2), SKAction.scaleBy(1/1.1, duration: repairDuration/2)])
            self.crossNode.runAction(actionShowRepairing, withKey: "showRepairing")
        }
    }
    
}