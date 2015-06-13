//
//  Explosion.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/5/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

let explosionName = "explosion"

class Explosion: SKNode {
    
    var fireNode: SKEmitterNode?
    var smokeNode: SKEmitterNode?
    var effectNode = SKNode()
    
    var lifeTime: Int
    var currentLifeTime: Int
    
    init(world: World, lifeTime: Int) {
        
        self.lifeTime = lifeTime
        self.currentLifeTime = lifeTime
        
        super.init()
        
        self.name = explosionName
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        self.currentLifeTime -= 1
        
//        var lifePercentage: CGFloat = (CGFloat(self.currentLifeTime)/CGFloat(self.lifeTime))*100
//        if lifePercentage < 0 {
//            lifePercentage = 0
//        }
//        println("Life Percentage: \(lifePercentage)")
//        switch lifePercentage {
//        case 75...100:
//            self.fireNode.hidden = false
//            self.smokeNode.hidden = false
//        case 50...75:
//            self.fireNode.hidden = true
//            self.fireNode.particleBirthRate = 0
//            self.smokeNode.hidden = false
//        case 1...50:
//            for node in effectNode.children {
//                if let emitterNode = node as? SKEmitterNode{
//                    emitterNode.particleBirthRate = 0
//                }
//            }
//        case 0...1:
//            self.removeFromParent()
//        default:
//            fatalError("ERROR: Unknown life percentage \(lifePercentage)% in explosion update() method")
//        }
    }
    
    
    
    
}