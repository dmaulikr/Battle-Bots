//
//  RocketExplosion.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/9/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit


class RocketExplosion: DamageExplosion {
    
    override init(world: World, lifeTime: Int, mechanism: Mechanism, damage: CGFloat, maxRadius: CGFloat) {
        
        super.init(world: world, lifeTime: lifeTime, mechanism: mechanism, damage: damage, maxRadius: maxRadius)
        
        self.mechanism = mechanism
        
        self.smokeNode =  NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("explosionAutoSmoke", ofType: "sks")!) as? SKEmitterNode
        self.fireNode =  NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("explosionAutoFire", ofType: "sks")!) as? SKEmitterNode
        
        self.smokeNode!.targetNode = world
        self.fireNode!.targetNode = world
        
        self.smokeNode!.particleZPosition = 20
        self.fireNode!.particleZPosition = 19
        
        self.damageNode.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.damageNode.physicsBody?.affectedByGravity = false
        self.damageNode.physicsBody?.categoryBitMask = physicsCategory.Explosion.rawValue
        self.damageNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.damageNode.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue | physicsCategory.Structure.rawValue | physicsCategory.Projectile.rawValue
        
        self.addChild(effectNode)
        self.addChild(damageNode)
        effectNode.addChild(smokeNode!)
        effectNode.addChild(fireNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        
        super.update()

        var lifePercentage: CGFloat = (CGFloat(self.currentLifeTime)/CGFloat(self.lifeTime))*100
        if lifePercentage < 0 {
            lifePercentage = 0
        }
        switch lifePercentage {
        case 50...100:
            self.smokeNode!.hidden = false
        case 30...60:
            self.smokeNode?.particleBirthRate = 0
        case 0...30:
            self.fireNode?.particleBirthRate = 0
            
            if self.actionForKey("waitAndRemove") == nil {
                
                let waitDuration = NSTimeInterval(self.smokeNode!.particleLifetime)
                let actionWaitAndRemove = SKAction.sequence([SKAction.waitForDuration(waitDuration), SKAction.runBlock({self.removeFromParent()})])
                self.runAction(actionWaitAndRemove, withKey: "waitAndRemove")
            }
        default:
            fatalError("ERROR: Unknown life percentage \(lifePercentage)% in explosion update() method")
        }
        
    }
    
    
    
    
}