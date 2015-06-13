//
//  DamageExplosion.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/9/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class DamageExplosion: Explosion {
    
    var mechanism: Mechanism? //The mech that fired the projectile which caused the explosion
    
    var maxRadius: CGFloat
    var affectedMechanisms = [Mechanism]()
    var damageNode = SKNode()
    var team: Team
    var damage: CGFloat
    
    init(world: World, lifeTime: Int, team: Team, damage: CGFloat, maxRadius: CGFloat) {
        
        self.damage = damage
        self.maxRadius = maxRadius
        self.team = team
        
        super.init(world: world, lifeTime: lifeTime)
    }
    
    init(world: World, lifeTime: Int, mechanism: Mechanism, damage: CGFloat, maxRadius: CGFloat) {
        
        self.damage = damage
        self.maxRadius = maxRadius
        
        self.team = mechanism.team
        
        super.init(world: world, lifeTime: lifeTime)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        if self.currentLifeTime == self.lifeTime {
            expandExplosion()
        }
        super.update()
    }
    
    func expandExplosion() {
        if self.damageNode.actionForKey("expandExplosion") == nil {
            let actionExpand = SKAction.scaleBy(self.maxRadius, duration: 0.5)
            let actionWaitAndRemove = SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.runBlock({self.damageNode.removeFromParent()})])
            let actionExpandAndRemove = SKAction.sequence([actionExpand,actionWaitAndRemove])
            self.damageNode.runAction(actionExpandAndRemove, withKey: "expandExplosion")
        }
    }
    
    func madeContactWith(_mechanism: Mechanism) {
        if _mechanism.team.name != self.team.name {
            if contains(self.affectedMechanisms, _mechanism) == false {
                self.affectedMechanisms.append(_mechanism)
                _mechanism.takeDamage(self.damage)
                if self.mechanism != nil {
                    _mechanism.team.addEnemyMechanism(self.mechanism!)
                }
            }
        }
    }
    
}