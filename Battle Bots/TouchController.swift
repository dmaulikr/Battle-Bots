//
//  TouchController.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/22/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class TouchController: SKNode {
    
    var touches = [UITouch]()
    var state: touchControllerState = .Idle
    let world: World
    var initialPositions = [CGPoint]() //Position in the world
    var initialDistanceForZoom: CGFloat? //Distances in the view (not world)
    var initialTouchTimeStamps: [NSTimeInterval] = []
    
    var shouldFollowMechanism = false
    var mechanismToFollowName: String?
    var mechanismToFollow: Mechanism?
    
    var previousPositionInWorld: CGPoint?
    var centerOfScene: CGPoint?
    var initialPositionOfWorld: CGPoint?
    
    var selectedAutos = [Auto]()
    
    var selectionNode: SelectionNode?
    
    init(world: World) {
        self.world = world
        super.init()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        self.updateCamera()
    }
    
    func updateCamera() {
        if shouldFollowMechanism {
            if let camera = self.world.childNodeWithName(cameraName) {
                camera.position = self.mechanismToFollow!.position
                if self.state == .isZooming {
                    centerOnNode(camera, immediately: true)
                }
                else {
                    if self.world.actionForKey(keyCentering) == nil && self.state != .isMovingView{
                        centerOnNode(camera, immediately: false)
                    }
                }
            }
        }
    }
    
    func addTouch(touch: UITouch) {
        
        for auto in self.selectedAutos {
            auto.deselect()
        }
        
        
        if self.touches.count < 2 && self.state == .Idle{
            self.touches.append(touch)
            self.initialTouchTimeStamps.append(touch.timestamp)
            self.initialPositions.append(touch.locationInNode(self.world))
            
            if self.initialPositionOfWorld == nil {
                self.initialPositionOfWorld = self.world.position
            }
            
            if self.touches.count == 2 {
                self.state = touchControllerState.isZooming
                self.initialDistanceForZoom = getDistance(self.touches[0].locationInNode(self.scene), self.touches[1].locationInNode(self.scene))
            }
        }
    }
    
    func removeTouch(touch: UITouch) {

        if contains(self.touches, touch) {
            let touchIndex = find(self.touches, touch)
            
            if touch.timestamp - self.initialTouchTimeStamps[touchIndex!] <= 0.50 && self.state == .Idle{
                self.shortTap(touch)
            }
            if self.state == .isSelecting {
                self.selectAutos()
            }
            
            self.resetProperties()
        }
    }
    
    func selectAutos() {
        self.selectedAutos = self.selectionNode!.autosInContactWith
        for auto in self.selectedAutos {
            auto.showAsSelected()
            println("Colorizing Auto")
        }
        self.state = .hasSelected
    }
    
    func resetProperties() {
        self.touches = []
        self.initialDistanceForZoom = nil
        self.initialTouchTimeStamps = []
        self.initialPositions = []
        self.selectionNode?.removeFromParent()
        self.selectionNode = nil
        self.previousPositionInWorld = nil
        self.centerOfScene = nil
        self.initialPositionOfWorld = nil
        self.state = .Idle
    }
    
    func touchMoved(touch: UITouch) {
        if self.touches.count == 2 {
            self.doZoom()
        }
        else if self.touches.count == 1 {
            switch self.state {
            case .Idle:
                let timeSinceTouchBegan = self.touches[0].timestamp - self.initialTouchTimeStamps[0]
                let distanceTouchMoved = getDistance(self.initialPositions[0], self.touches[0].locationInNode(self.world))
//                if timeSinceTouchBegan > 0.5 && distanceTouchMoved <= 50{
//                    self.doMoveView()
//                }
//                else if distanceTouchMoved > 50 {
//                    self.doSelection()
//                }
                if timeSinceTouchBegan > 0.5 {
                    self.doSelection()
                }
                else if distanceTouchMoved > 50 {
                    self.doMoveView()
                }
            case .isMovingView:
                self.doMoveView()
            case .isSelecting:
                self.doSelection()
            default:
                println("Doing short tap")
            }
            
        }
    }
    
    func doMoveView() {
        self.state = .isMovingView
//        if self.previousPositionInWorld == nil {
//            self.previousPositionInWorld = self.initialPositions[0]
//        }
        
        let initialPointInWorld = CGPoint(x: self.initialPositions[0].x, y: self.initialPositions[0].y)
        let currentPointInWorld = self.touches[0].locationInNode(self.world)
        let initialPositionInScene = self.world.convertPoint(initialPointInWorld, toNode: self.world.parent!)
        let currentPositionInScene = self.world.convertPoint(currentPointInWorld, toNode: self.world.parent!)

        let xDist = currentPositionInScene.x - initialPositionInScene.x
        let yDist = currentPositionInScene.y - initialPositionInScene.y
        
        let multiplier: CGFloat = 5.0 //Determines the speed of scroll movement
        
        let newPosition = CGPoint(x: self.initialPositionOfWorld!.x + xDist*multiplier, y: self.initialPositionOfWorld!.y + yDist*multiplier)
        
//        let centerOfView = CGPoint(x: CGRectGetMidX(self.world.scene!.frame), y: CGRectGetMidY(self.world.scene!.frame))
//        let centerOfViewInWorld = self.world.scene!.convertPoint(centerOfView, toNode: self.world)
//        let actionRepositionCamera = SKAction.runBlock({
//            println("TRYING TO MOVE CAMERA")
//            if let camera = self.world.childNodeWithName(cameraName) {
//            camera.position = centerOfViewInWorld
//            println("MOVING CAMERA TO \(centerOfViewInWorld)")
//            }})
        
        var actionRepositionCamera = SKAction.waitForDuration(0) //Will override in next if statement
        
        if let overlay = self.world.scene?.childNodeWithName(overlayName) {
            
            let centerOfViewInWorld = self.world.convertPoint(CGPoint(x: 0,y: 0), fromNode: overlay.parent!)
            
            actionRepositionCamera = SKAction.runBlock({
                println("TRYING TO MOVE CAMERA")
                if let camera = self.world.childNodeWithName(cameraName) {
                    camera.position = centerOfViewInWorld
                    println("MOVING CAMERA TO \(centerOfViewInWorld)")
                }})
        }
        
        let actionSequence = SKAction.sequence([SKAction.moveTo(newPosition, duration: 0.50),actionRepositionCamera])
        
        self.world.runAction(actionSequence)
        
    }
    
    func doZoom() {
        let currentDistance = getDistance(self.touches[0].locationInNode(self.scene), self.touches[1].locationInNode(self.scene))
        let scaleChangePercentage = (currentDistance - self.initialDistanceForZoom!)/self.initialDistanceForZoom!
        
        let scaleChangeAmount = self.world.xScale * scaleChangePercentage
        
        var scalePercentage = self.world.xScale + scaleChangeAmount/20
        
        if scalePercentage > maximumZoomScale {
            scalePercentage = maximumZoomScale
        }
        else if scalePercentage < minimumZoomScale {
            scalePercentage = minimumZoomScale
        }
        
        if let camera = self.world.childNodeWithName(cameraName) {
            if self.shouldFollowMechanism {
                camera.position = self.mechanismToFollow!.position
            }
            centerOnNode(camera, immediately: true)
        }
        
        self.world.setScale(scalePercentage)
    }
    
    func doSelection() {
        self.state = .isSelecting
        self.createSelectionNode()
        self.selectionNode?.update(self.touches[0].locationInNode(self.world))
    }
    
    func createSelectionNode() {
        if self.selectionNode == nil {
            self.selectionNode = SelectionNode(origin: self.initialPositions[0])
            self.world.addChild(self.selectionNode!)
        }
    }
    
    func shortTap(touch: UITouch) {
        let location = touch.locationInNode(world)
        let nearestMechanism = findNearestMechanism(location)
        if getDistance(nearestMechanism.position, location) <= 50 {
            shouldFollowMechanism = true
            mechanismToFollow = nearestMechanism
        }
        else{
            shouldFollowMechanism = false
            self.moveCameraTo(location, immediately: false)
        }
    }
    
    func centerOnNode(node: SKNode, immediately: Bool) {
        let cameraPositionInScene: CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!)
        
        let newLocation = CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y:node.parent!.position.y - cameraPositionInScene.y)
        if immediately {
            node.parent!.position = newLocation
        }
        else {
            node.parent!.runAction(SKAction.moveTo(newLocation, duration: 0.5), withKey: keyCentering)
        }
    }
    
    func findNearestMechanism(point: CGPoint) -> Mechanism {
        var mechanisms: [Mechanism] = []
        var mechanismDistances: [CGFloat] = []
        
        world.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            let mechanism = node as! Mechanism
            mechanisms.append(mechanism)
            mechanismDistances.append(getDistance(point, mechanism.position))
        }
        return mechanisms[find(mechanismDistances,minElement(mechanismDistances))!]
    }
    
    func moveCameraTo(location: CGPoint, immediately: Bool) {
        if let camera = self.world.childNodeWithName(cameraName) {
            camera.position = location
            centerOnNode(camera, immediately: immediately)
        }
    }
    
    
    
}