//
//  Miner.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/12/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var minerNameCount: Int = 0

class Miner: Auto {
    
    var oreAmount: CGFloat = 0
    var oreMaxCapacity: CGFloat = minerOreMaxCapacity
    var mineAmount = minerMineAmount
    var isMining: Bool = false
    var oreDepositsInContactWith = [OreDeposit]()
    
    var drillNode: SKSpriteNode
    
    override init(team: Team, world: World) {
        
        self.drillNode = SKSpriteNode(imageNamed: "Drill")
        self.drillNode.setScale(autosScale)
        
        super.init(team: team, world: world)
        
        self.fsm = FSM(_states: minerStates)
        
        minerNameCount += 1
        self.name! += "miner\(minerNameCount)"
        
        self.type = .Miner
        self.oreCost = minerOreCost
        self.health = minerHealth
        self.maxHealth = minerHealth
        self.energy = minerEnergy
        self.maxEnergy = minerEnergy
        self.baseSpeed = minerBaseSpeed
        self.baseRotateSpeed = minerBaseRotateSpeed
        self.sightRadius = minerSightRadius
        
        self.sightNode = SKShapeNode(circleOfRadius: self.sightRadius!)
        self.sightNode!.fillColor = sightNodeFillColor
        self.sightNode!.strokeColor = sightNodeStrokeColor
        
        self.chassisNode = SKSpriteNode(imageNamed: "MinerChassis")
        self.chassisNode.setScale(autosScale)
        
        self.mobilityNode = SKSpriteNode(imageNamed: "Wheels")
        self.mobilityNode.setScale(autosScale)
        
        self.sightNode!.zPosition = 1
        self.mobilityNode.zPosition = 2
        self.chassisNode.zPosition = 3
        self.drillNode.zPosition = 4
        
        self.bodyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: chassisNode.frame.width, height: chassisNode.frame.height))
        self.bodyNode.physicsBody?.affectedByGravity = false
        self.bodyNode.physicsBody?.categoryBitMask = physicsCategory.Auto.rawValue
        self.bodyNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.bodyNode.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Projectile.rawValue | physicsCategory.Structure.rawValue | physicsCategory.Ore.rawValue
        
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
        self.bodyNode.addChild(drillNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSparkEmitter() {
        let sparkEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("drillSparks", ofType: "sks")!) as? SKEmitterNode
        sparkEmitterNode?.particleZPosition = 50
        sparkEmitterNode?.position = CGPoint(x: 0, y: self.drillNode.frame.height)
        self.drillNode.addChild(sparkEmitterNode!)
        
        sparkEmitterNode?.targetNode = self.world
        let waitTime: NSTimeInterval = NSTimeInterval(3)
        let actionWait = SKAction.waitForDuration(waitTime)
        let actionWaitForParticleLifeTime = SKAction.waitForDuration(NSTimeInterval(sparkEmitterNode!.particleLifetime))
        let actionSetBirthRateToZero = SKAction.runBlock({sparkEmitterNode!.particleBirthRate = 0})
        let actionRemoveSparkNode = SKAction.runBlock({sparkEmitterNode?.removeFromParent()})
        let actionWaitAndRemoveSpark = SKAction.sequence([actionWait,actionSetBirthRateToZero,actionWaitForParticleLifeTime,actionRemoveSparkNode])
        self.runAction(actionWaitAndRemoveSpark)
    }
    
    func transferOre(oreDeposit: OreDeposit) {
        if oreDeposit.amount < self.mineAmount {
            if oreDeposit.amount > self.oreMaxCapacity - self.oreAmount {
                oreDeposit.amount -= self.oreMaxCapacity - self.oreAmount
                self.oreAmount = self.oreMaxCapacity
            }
            else {
                self.oreAmount += oreDeposit.amount
                oreDeposit.mine(oreDeposit.amount)
            }
        }
        else {
            if self.mineAmount > self.oreMaxCapacity - self.oreAmount {
                oreDeposit.amount -= self.oreMaxCapacity - self.oreAmount
                self.oreAmount = self.oreMaxCapacity
            }
            else {
                oreDeposit.mine(self.mineAmount)
                self.oreAmount += self.mineAmount
            }
        }
    }
    
    func mine(oreDeposit: OreDeposit) {
        let keyMining = "mining"
        
        if self.isMining == false && oreDeposit.amount > 0 && self.oreAmount/self.oreMaxCapacity < 1.0{
            self.isMining = true
            
//            if oreDeposit.amount < self.mineAmount {
//                self.oreAmount += oreDeposit.amount
//                oreDeposit.mine(oreDeposit.amount)
//            }
//            else {
//                oreDeposit.mine(self.mineAmount)
//                self.oreAmount += self.mineAmount
//            }
            
            let drillMovementDuration: NSTimeInterval = 2.0
            let drillMoveDistance = self.chassisNode.frame.height/2
            
            let actionMoveDrillForward = SKAction.moveByX(0, y: drillMoveDistance, duration: drillMovementDuration)
            let actionMoveDrillBack = SKAction.moveByX(0, y: -drillMoveDistance, duration: drillMovementDuration)
            
            let actionDrillSequence = SKAction.sequence([SKAction.runBlock({self.makeSparkEmitter()}), actionMoveDrillForward, actionMoveDrillBack])
            
            self.drillNode.runAction(actionDrillSequence, completion: {self.isMining = false; self.transferOre(oreDeposit)})
        }
    }
    
    func depositOre(HQ: Headquarters) {
        if HQ.team.name == self.team.name {
            HQ.team.depositOre(self.oreAmount)
            self.oreAmount = 0
        }
    }
    
    func didCollideWithOreDeposit(oreDeposit: OreDeposit) {
        if contains(self.oreDepositsInContactWith, oreDeposit) == false {
            self.oreDepositsInContactWith.append(oreDeposit)
        }
    }
    
    func didEndCollisionWithOreDeposit(oreDeposit: OreDeposit) {
        if contains(self.oreDepositsInContactWith, oreDeposit) {
            self.oreDepositsInContactWith.removeAtIndex(find(self.oreDepositsInContactWith, oreDeposit)!)
        }
    }
}