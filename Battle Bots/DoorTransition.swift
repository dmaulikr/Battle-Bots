//
//  DoorTransition.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/10/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class DoorTransition: SKNode {
    
    var overlap: CGFloat = 1
    
    var type: doorType
    var state: doorState
    
    var leftDoorNode: SKSpriteNode?
    var rightDoorNode: SKSpriteNode?
    
    var topDoorNode: SKSpriteNode?
    var bottomDoorNode: SKSpriteNode?
    
    init(type: doorType, scene: SKScene, initialState: doorState) {
        
        self.type = type
        self.state = initialState
        
        super.init()
        //scene.addChild(self)
        
        self.position = CGPoint(x: 0,y: 0)
        
        switch self.type {
        case .Vertical:
            topDoorNode = SKSpriteNode(imageNamed: "MetalDoor")
            bottomDoorNode = SKSpriteNode(imageNamed: "MetalDoor")
            
            topDoorNode?.setScale(doorTransitionScale)
            bottomDoorNode?.setScale(doorTransitionScale)
            
            if self.state == .Open {
                topDoorNode?.position = CGPoint(x: 0, y: topDoorNode!.frame.height/2 + scene.view!.bounds.height/2)
                bottomDoorNode?.position = CGPoint(x: 0, y: -(bottomDoorNode!.frame.height/2 + scene.view!.bounds.height/2))
            }
            else if self.state == .Closed {
                topDoorNode?.position = CGPoint(x: 0, y: topDoorNode!.frame.height/2 - overlap)
                bottomDoorNode?.position = CGPoint(x: 0, y: -(bottomDoorNode!.frame.height/2) + overlap)
            }
            
            topDoorNode?.zPosition = 100
            bottomDoorNode?.zPosition = 100
            
            self.addChild(topDoorNode!)
            self.addChild(bottomDoorNode!)
            
        case .Horizontal:
            leftDoorNode = SKSpriteNode(imageNamed: "MetalDoor")
            rightDoorNode = SKSpriteNode(imageNamed: "MetalDoor")
            
            leftDoorNode?.setScale(doorTransitionScale)
            rightDoorNode?.setScale(doorTransitionScale)
            
            if self.state == .Open {
                leftDoorNode?.position = CGPoint(x: -(leftDoorNode!.frame.width/2 + scene.view!.bounds.width/2), y: 0)
                rightDoorNode?.position = CGPoint(x: rightDoorNode!.frame.width/2 + scene.view!.bounds.width/2, y: 0)
            }
            else if self.state == .Closed {
                leftDoorNode?.position = CGPoint(x: -(leftDoorNode!.frame.width/2) + overlap, y: 0)
                rightDoorNode?.position = CGPoint(x: rightDoorNode!.frame.width/2 - overlap, y: 0)
            }
            
            leftDoorNode?.zPosition = 100
            rightDoorNode?.zPosition = 100
            
            self.addChild(leftDoorNode!)
            self.addChild(rightDoorNode!)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeDoors(duration: NSTimeInterval) {
        switch self.type {
        case .Vertical:
            if self.topDoorNode?.actionForKey("movingDoor") == nil && self.topDoorNode?.actionForKey("movingDoor") == nil {
                self.topDoorNode?.runAction(SKAction.moveByX(0, y: -(self.scene!.view!.bounds.height/2 + overlap), duration: duration), withKey: "movingDoor")
                self.bottomDoorNode?.runAction(SKAction.moveByX(0, y: self.scene!.view!.bounds.height/2 + overlap, duration: duration), withKey: "movingDoor")
            }
        case .Horizontal:
            if self.leftDoorNode?.actionForKey("movingDoor") == nil && self.rightDoorNode?.actionForKey("movingDoor") == nil {
                self.leftDoorNode?.runAction(SKAction.moveByX(self.scene!.view!.bounds.width/2 + overlap, y: 0, duration: duration), withKey: "movingDoor")
                self.rightDoorNode?.runAction(SKAction.moveByX(-(self.scene!.view!.bounds.width/2 + overlap), y: 0, duration: duration), withKey: "movingDoor")
            }
        }
        self.state = .Closed
    }
    
    func openDoors(duration: NSTimeInterval) {
        switch self.type {
        case .Vertical:
            if self.topDoorNode?.actionForKey("movingDoor") == nil && self.topDoorNode?.actionForKey("movingDoor") == nil {
                self.topDoorNode?.runAction(SKAction.moveByX(0, y: self.scene!.view!.bounds.height/2 + 1, duration: duration), withKey: "movingDoor")
                self.bottomDoorNode?.runAction(SKAction.moveByX(0, y: -(self.scene!.view!.bounds.height/2 + 1), duration: duration), withKey: "movingDoor")
            }
        case .Horizontal:
            if self.leftDoorNode?.actionForKey("movingDoor") == nil && self.rightDoorNode?.actionForKey("movingDoor") == nil {
                self.leftDoorNode?.runAction(SKAction.moveByX(-(self.scene!.view!.bounds.width/2 + 1), y: 0, duration: duration), withKey: "movingDoor")
                self.rightDoorNode?.runAction(SKAction.moveByX((self.scene!.view!.bounds.width/2 + 1), y: 0, duration: duration), withKey: "movingDoor")
            }
        }
        self.state = .Open
    }
    
    
    
}