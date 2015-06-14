//
//  Auto.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Auto: Mechanism {
    
    override var mechType: mechanismType? {
        get{return .Auto}
        set{self.mechType = .Auto}
    }
    
    override var maxGuardPositions: Int {
        get{return autoMaxGuardPostitions}
        set{self.maxGuardPositions = autoMaxGuardPostitions}
    }
    
    var underPlayerControl: Bool = false
    
    var maxEnergy: CGFloat? = nil
    var energy: CGFloat? = nil
    var baseSpeed: CGFloat? = nil
    var baseRotateSpeed: CGFloat? = nil
    var sightRadius: CGFloat? = nil
    
    var bodyNode = SKNode()
    var chassisNode = SKSpriteNode()
    var mobilityNode = SKSpriteNode()
    var healthBar = HealthBar(type: .Auto)
    
//    var sightNode = SKShapeNode()
    
    var type: autoType = .Default
    
    override init(team: Team, world: World) {
        
        super.init(team: team, world: world)
        
        healthBar.zPosition = 10
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        loseEnergy()
        self.healthBar.update(self.health, maxHealth: self.maxHealth, energy: self.energy!, maxEnergy: self.maxEnergy!)
    }
    
    func loseEnergy() {
        self.energy! -= 0.01
        if (self.actionForKey(keyMoveTo) == nil) {
            self.energy! -= 0.04
        }
        if self.energy < 0 {
            self.energy = 0
        }
        if self.energy == 0 && self.fsm?.isActive == true {
            self.fsm?.pause()
        }
    }
    
    override func repair(amount: CGFloat) {
        if self.bodyNode.actionForKey(keyRepair) == nil {
            self.bodyNode.runAction(actionRepairAuto, withKey: keyRepair)
            super.repair(amount)
        }
    }
    
    func recharge(amount: CGFloat) {
        if self.bodyNode.actionForKey(keyRecharge) == nil {
            self.bodyNode.runAction(actionRechargeAuto, withKey: keyRecharge)
            self.energy! += amount
            if self.energy > self.maxEnergy {
                self.energy = self.maxEnergy
            }
        }
    }
    
    override func destroy() {
        let explosion = AutoExplosion(world: self.world, lifeTime: 180)
        explosion.position = self.position
        self.world.addChild(explosion)
        super.destroy()
    }
    
    func playerTakeControl() {
        self.underPlayerControl = true
        self.fsm!.pause()
    }
    
    func playerReturnControl() {
        self.underPlayerControl = false
        self.fsm!.resume()
    }
    
    func moveTo(destination: CGPoint, speed: CGFloat, rotateSpeed: CGFloat) -> Bool {
        
        if self.world.boundary!.containsPosition(destination) {
            let location = CGPointMake(self.position.x, self.position.y)
            
            if destination != location { //This is to prevent a bug that cause the bot's position to become (nan,nan)
                let distance = getDistance(destination, location)
                
                let duration: NSTimeInterval = Double(distance / speed)
                
                let actionRotate = getActionRotateNodeTowardsPoint(self.bodyNode, self.world.convertPoint(destination, toNode: self), rotateSpeed)
                let actionMove = SKAction.runBlock({self.runAction(SKAction.moveTo(destination, duration: duration), withKey: keyMoveTo)})
                let actionRotateThenMove = SKAction.sequence([actionRotate, actionMove])
                
                self.bodyNode.runAction(actionRotateThenMove, withKey: keyRotateTowardsPoint)
                
                return true
            }
        }
        return false
        
    }
    
    override func takeDamage(amount: CGFloat) {
        super.takeDamage(amount)
        for child in self.bodyNode.children {
            if let spriteNode = child as? SKSpriteNode {
                if spriteNode.actionForKey(keyTakeDamage) == nil {
                    spriteNode.runAction(actionTakeDamage, withKey: keyTakeDamage)
                }
            }
        }
    }
    
}