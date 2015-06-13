//
//  StructureExplosion.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class StructureExplosion: Explosion {
    
    override init(world: World, lifeTime: Int) {
        super.init(world: world, lifeTime: lifeTime)
        
        self.smokeNode =  NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("explosionStructureSmoke", ofType: "sks")!) as? SKEmitterNode
        self.fireNode =  NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("explosionStructureFire", ofType: "sks")!) as? SKEmitterNode
        
        self.smokeNode!.targetNode = world
        self.fireNode!.targetNode = world
        
        self.smokeNode!.particleZPosition = 19
        self.fireNode!.particleZPosition = 20
        
        
        self.addChild(effectNode)
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
            self.fireNode!.hidden = false
            self.smokeNode!.hidden = false
        case 10...50:
            self.fireNode!.particleBirthRate = 0
        case 0...20:
            self.smokeNode!.particleBirthRate = 0
            
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