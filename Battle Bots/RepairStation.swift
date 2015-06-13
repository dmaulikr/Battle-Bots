//
//  RepairStation.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/3/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var repairStationNameCount: Int = 0

class RepairStation: Structure {
    
    override var type: structureType {
        get{return .RepairStation}
        set{self.type = .RepairStation}
    }
    
    var repairAmount: CGFloat = RSRepairAmount
    
    var layer_1 = SKSpriteNode(imageNamed: "RepairStation_1")
    var layer_2 = SKSpriteNode(imageNamed: "RepairStation_2")
    
    override init(team: Team, world: World) {
        super.init(team: team, world: world)
        
        repairStationNameCount += 1
        self.name! += "repairStation\(repairStationNameCount)"
        
        layer_1.setScale(structuresScale)
        layer_2.setScale(structuresScale)
        
        layer_1.zPosition = 0
        layer_2.zPosition = 10
        
        buildingNode.addChild(layer_1)
        buildingNode.addChild(layer_2)
        
        self.sightRadius = RSSightRadius
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode!.fillColor = sightNodeFillColor
        self.sightNode!.strokeColor = sightNodeStrokeColor
        
        self.addChild(sightNode!)
        self.addChild(healthBar)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: layer_1.frame.width/2)
        //self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: layer_2.frame.width, height: layer_2.frame.height))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = physicsCategory.Structure.rawValue
        self.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Projectile.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func takeDamage(amount: CGFloat) {
        super.takeDamage(amount)
        self.layer_1.runAction(actionTakeDamage)
        self.layer_2.runAction(actionTakeDamage)
    }
    
}