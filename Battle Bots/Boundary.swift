//
//  Boundary.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/11/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Boundary: SKNode {
    
    var size: CGSize
    
    var backgroundNode: SKSpriteNode
    
    init(imageName: String) {
        
        
        self.backgroundNode = SKSpriteNode(imageNamed: imageName)
        self.backgroundNode.setScale(structuresScale)
        self.backgroundNode.zPosition = -1
        
        self.size = CGSize(width: self.backgroundNode.frame.width, height: self.backgroundNode.frame.height)
        
        super.init()
        
        self.addChild(backgroundNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func containsPosition(position: CGPoint) -> Bool {
        if self.backgroundNode.containsPoint(position) {
            return true
        }
        else {
            return false
        }
    }
    
    
}