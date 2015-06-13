//
//  World.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/11/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class World: SKNode {
    
    var boundary: Boundary?
    
    init(boundaryImageName: String) {
        super.init()
        
        self.boundary = Boundary(imageName: boundaryImageName)
        self.addChild(boundary!)

    }
    
    override init() {
        super.init()
        self.boundary = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeBoundaryTo(boundaryImageName: String) {
        if self.boundary?.parent != nil {
            self.boundary?.removeFromParent()
        }
        self.boundary = Boundary(imageName: boundaryImageName)
        self.addChild(boundary!)
    }
    
}