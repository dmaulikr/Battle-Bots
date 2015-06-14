//
//  Headquarters.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var headquartersNameCount: Int = 0

class Headquarters: Structure {
    
    override var type: structureType {
        get{return .Headquarters}
        set{self.type = .Headquarters}
    }
    
    var layer_1 = SKSpriteNode(imageNamed: "HQ_1")
    var layer_2 = SKSpriteNode(imageNamed: "HQ_2")
    
    override init(team: Team, world: World) {
        super.init(team: team, world: world)
        
        headquartersNameCount += 1
        self.name! += "headQuarters\(headquartersNameCount)"
        
        self.fsm = FSM(_states: HQStates)
        
        layer_1.setScale(structuresScale)
        layer_2.setScale(structuresScale)
        
        layer_1.zPosition = 0
        layer_2.zPosition = 10
        
        buildingNode.addChild(layer_1)
        buildingNode.addChild(layer_2)
        
        self.health = HQHealth
        self.maxHealth = HQHealth
        self.sightRadius = HQSightRadius
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode!.fillColor = sightNodeFillColor
        self.sightNode!.strokeColor = sightNodeStrokeColor
        
        self.addChild(sightNode!)
        self.addChild(healthBar)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: layer_1.frame.width/2)
        //self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: layer_1.frame.width/2, height: layer_1.frame.height/2))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = physicsCategory.Structure.rawValue
        self.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Projectile.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
    }
    
    override func takeDamage(amount: CGFloat) {
        super.takeDamage(amount)
        self.layer_1.runAction(actionTakeDamage)
        self.layer_2.runAction(actionTakeDamage)
    }
    
    override func destroy() {
        if self.team.mechanisms.isEmpty == false {
            self.team.remove(self)
            for member in self.team.mechanisms {
                let mechanism = member as Mechanism
                mechanism.destroy()
            }
        }
        super.destroy()
    }
    
    func buildAuto(type: autoType) {
        if self.team.oreAmount >= getOreCostOfAutoType(type) {
            makeAuto(self.world, self.team, self.position, type)
            self.team.oreAmount -= getOreCostOfAutoType(type)
        }
    }
    
    
}