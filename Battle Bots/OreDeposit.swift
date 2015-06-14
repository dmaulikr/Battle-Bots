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
            spriteImageName = "OreDepositSmall"
        case .Medium:
            self.amount = mediumOreAmount
            self.physicsRadius = mediumOreRadius
            spriteImageName = "OreDepositMedium"
        case .Large:
            self.amount = largeOreAmount
            self.physicsRadius = largeOreRadius
            spriteImageName = "OreDepositLarge"
        case .Huge:
            self.amount = hugeOreAmount
            self.physicsRadius = hugeOreRadius
            spriteImageName = "OreDepositHuge"
        }
        
        let defaultTexture = SKTexture(imageNamed: "OreDepositHuge")
        let texture = SKTexture(imageNamed: spriteImageName)
        
        self.spriteNode = SKSpriteNode(texture: defaultTexture)
        self.spriteNode.texture = texture
        self.spriteNode.setScale(oreScale)
        
        
        super.init()
        
        oreNameCount += 1
        self.name = "ore\(oreNameCount)"
        
        self.physicsNode.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.physicsNode.physicsBody?.affectedByGravity = false
        self.physicsNode.physicsBody?.categoryBitMask = physicsCategory.Ore.rawValue
        self.physicsNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.physicsNode.physicsBody?.contactTestBitMask = physicsCategory.Sight.rawValue | physicsCategory.Auto.rawValue
        

        self.addChild(physicsNode)
        self.addChild(spriteNode)
        
        
        self.physicsNode.setScale(self.physicsRadius)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
        if self.amount > largeOreAmount {
            self.size = .Huge
            var texture = SKTexture(imageNamed: "OreDepositHuge")
            self.physicsRadius = hugeOreRadius
            self.spriteNode.texture = texture
        }
        else if self.amount > mediumOreAmount {
            self.size = .Large
            var texture = SKTexture(imageNamed: "OreDepositLarge")
            self.physicsRadius = largeOreRadius
            self.spriteNode.texture = texture
        }
        else if self.amount > smallOreAmount {
            self.size = .Medium
            var texture = SKTexture(imageNamed: "OreDepositMedium")
            self.physicsRadius = mediumOreRadius
            self.spriteNode.texture = texture
        }
        else {
            self.size = .Small
            var texture = SKTexture(imageNamed: "OreDepositSmall")
            self.physicsRadius = smallOreRadius
            self.spriteNode.texture = texture
        }
        
        resizePhysicsNode()
    }
    
    func resizePhysicsNode() {
        self.physicsNode.setScale(self.physicsRadius)
    }
    
    func removeFromArrays() {
        self.world.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            if let mechanism = node as? Mechanism {
                mechanism.team.removeOreDeposit(self)
                if let miner = mechanism as? Miner {
                    miner.didEndCollisionWithOreDeposit(self)
                }
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
        else {
            self.update()
        }
    }
    
}