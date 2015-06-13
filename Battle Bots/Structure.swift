//
//  Structure.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Structure: Mechanism {
    
    override var mechType: mechanismType? {
        get{return .Structure}
        set{self.mechType = .Structure}
    }
    
    override var maxGuardPositions: Int {
        get{return structureMaxGuardPostitions}
        set{self.maxGuardPositions = structureMaxGuardPostitions}
    }
    
    var type: structureType = .Default
    var healthBar = HealthBar(type: .Structure)
    var buildingNode = SKNode()
    var sightNode: SKShapeNode?
    var sightRadius: CGFloat?
    
    override init(team: Team, world: World) {
        super.init(team: team, world: world)
        
        self.fsm = FSM()
        fsm!.setNewTarget(self)
        
        healthBar.zPosition = 10
        healthBar.position = CGPoint(x: 0, y: 0)
        self.addChild(buildingNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        super.update()
        self.healthBar.update(self.health, maxHealth: self.maxHealth)
    }
    
    override func takeDamage(amount: CGFloat) {
        super.takeDamage(amount)
        for child in self.buildingNode.children {
            if let spriteNode = child as? SKSpriteNode {
                if spriteNode.actionForKey(keyTakeDamage) == nil {
                    spriteNode.runAction(actionTakeDamage, withKey: keyTakeDamage)
                }
            }
        }
    }
    
    override func destroy() {
        let explosion = StructureExplosion(world: self.world, lifeTime: 300)
        explosion.position = self.position
        self.world.addChild(explosion)
        super.destroy()
    }
    
    override func repair(amount: CGFloat) {
        if self.buildingNode.actionForKey(keyRepair) == nil {
            self.buildingNode.runAction(actionRepairStructure, withKey: keyRepair)
            super.repair(amount)
        }
    }
    
    
    
}