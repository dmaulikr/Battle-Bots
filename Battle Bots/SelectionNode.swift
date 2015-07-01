//
//  SelectionNode.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class SelectionNode: SKNode {
    
    var origin: CGPoint
    var newPoint: CGPoint?
    
    var autosInContactWith = [Auto]()
    
    var shapeNode: SKShapeNode?
    
    let physicsBodyNode = SKNode()
    
    
    init(origin: CGPoint) {
        //self.shapeNode = SKShapeNode(circleOfRadius: 1)
        self.origin = origin
        super.init()
        
//        self.shapeNode.strokeColor = selectionNodeStrokeColor
//        self.shapeNode.fillColor = selectionNodeFillColor
        let rectangle = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        self.physicsBodyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 2, height: 2))
        self.physicsBodyNode.physicsBody?.affectedByGravity = false
        self.physicsBodyNode.physicsBody?.categoryBitMask = physicsCategory.Selection.rawValue
        self.physicsBodyNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.physicsBodyNode.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue
        self.addChild(physicsBodyNode)
        
        self.position = self.origin
        //self.addChild(self.shapeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(newPoint: CGPoint) {
        self.newPoint = newPoint
        
        //self.scaleShapeNode()
        self.createNewShapeNode()
        self.resizePhysicsBody()
        //self.repositionShapeNode()
    }
    
    func scaleShapeNode() {
        let xDist = self.newPoint!.x - self.origin.x
        let yDist = self.newPoint!.y - self.origin.y
        
        self.shapeNode!.xScale = xDist/2
        self.shapeNode!.yScale = yDist/2
    }
    
    func createNewShapeNode() {
        let xDist = self.newPoint!.x - self.origin.x
        let yDist = self.newPoint!.y - self.origin.y
        let rectFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: xDist, height: yDist))
        
        if self.shapeNode != nil {
            self.shapeNode!.removeFromParent()
        }
        //self.shapeNode = SKShapeNode(ellipseInRect: rectFrame)
        let newSize = CGSize(width: xDist, height: yDist)
        let newRect = CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
        self.shapeNode = SKShapeNode(rect: newRect)
        
        self.addChild(shapeNode!)
        
        self.shapeNode!.strokeColor = selectionNodeStrokeColor
        self.shapeNode!.fillColor = selectionNodeFillColor
        self.shapeNode!.zPosition = 30
        
    }
    
    func resizePhysicsBody() {
        let xDist = self.newPoint!.x - self.origin.x
        let yDist = self.newPoint!.y - self.origin.y
        
        self.physicsBodyNode.xScale = abs(xDist/2)
        self.physicsBodyNode.yScale = abs(yDist/2)
        
        let width = self.shapeNode!.frame.width
        let height = self.shapeNode!.frame.height
        
        if xDist >= 0 {
            self.physicsBodyNode.position.x = width/2
        }
        else {
            self.physicsBodyNode.position.x = -width/2
        }
        
        if yDist >= 0 {
            self.physicsBodyNode.position.y = height/2
        }
        else {
            self.physicsBodyNode.position.y = -height/2
        }
        
//        let shapeNodeCenterPoint = CGPoint(x: self.shapeNode!.frame.width/2, y: self.shapeNode!.frame.height/2)
//        self.physicsBodyNode.position = shapeNodeCenterPoint
    }
    
//    func createPhysicsBody() {
//        if self.shapeNode != nil {
//            self.shapeNode!.physicsBody = SKPhysicsBody(edgeLoopFromPath: self.shapeNode?.path)
//            self.shapeNode!.physicsBody?.affectedByGravity = false
//            self.shapeNode!.physicsBody?.categoryBitMask = physicsCategory.Selection.rawValue
//            self.shapeNode!.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
//            self.shapeNode!.physicsBody?.contactTestBitMask = physicsCategory.Auto.rawValue
//        }
//    }
    
    
    func didCollideWithAuto(auto: Auto) {
        if contains(self.autosInContactWith, auto) == false {
            self.autosInContactWith.append(auto)
            println("Adding Auto To SelectionNode")
        }
    }
    
    func didEndCollisionWithAuto(auto: Auto) {
        if contains(self.autosInContactWith, auto) {
            self.autosInContactWith.removeAtIndex(find(self.autosInContactWith,auto)!)
            println("Removing Auto From SelectionNode")
        }
    }
    
    
    
}