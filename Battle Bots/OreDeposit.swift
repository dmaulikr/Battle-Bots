//
//  OreDeposit.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/12/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var oreNameCount: Int = 0

class OreDeposit: SKNode {
    
    var size: oreSize
    var amount: CGFloat
    var physicsRadius: CGFloat
    
    var world: World
    
    var spriteNode: SKSpriteNode
    var physicsNode = SKNode()
    
    init(size: oreSize, world: World) {
        
        self.world = world
        self.size = size
        
        var spriteImageName: String
        
        switch size {
        case .Small:
            self.amount = smallOreAmount
            self.physicsRadius = smallOreRadius
            spriteImageName = "ChargingStation_2"
        case .Medium:
            self.amount = mediumOreAmount
            self.physicsRadius = mediumOreRadius
            spriteImageName = "ChargingStation_2"
        case .Large:
            self.amount = largeOreAmount
            self.physicsRadius = largeOreRadius
            spriteImageName = "ChargingStation_2"
        case .Huge:
            self.amount = hugeOreAmount
            self.physicsRadius = hugeOreRadius
            spriteImageName = "ChargingStation_2"
        }
        
        self.spriteNode = SKSpriteNode(imageNamed: spriteImageName)
        
        super.init()
        
        oreNameCount += 1
        self.name = "ore\(oreNameCount)"
        
        self.physicsNode.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = physicsCategory.Ore.rawValue
        self.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.physicsBody?.contactTestBitMask = physicsCategory.Sight.rawValue | physicsCategory.Auto.rawValue
    

        self.addChild(physicsNode)
        self.addChild(spriteNode)
        
        self.physicsNode.setScale(self.physicsRadius)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
    }
    
    func removeFromArrays() {
        self.world.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            if let mechanism = node as? Mechanism {
                mechanism.team.removeOreDeposit(self)
            }
        }
    }
    
    func destroy() {
        self.removeFromArrays()
        self.removeFromParent()
    }
    
    func mine(amount: CGFloat) {
        self.amount -= amount
        if self.amount <= 0 {
            self.destroy()
        }
    }
    
}