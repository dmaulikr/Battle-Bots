//
//  LevelSelectScene.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSelectScene: SKScene {
    
    // The root node of your game world. Attach game entities
    // (player, enemies, &c.) to here.
    var world: SKNode?
    // The root node of our UI. Attach control buttons & state
    // indicators here.
    var overlay: SKNode?
    // The camera. Move this node to change what parts of the world are visible.
    var camera: SKNode?
    
    var doorTransition: DoorTransition?
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = colorMenuBackground
        
        // Camera setup
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.world = SKNode()
        //self.world?.name = worldName
        self.addChild(self.world!)
        self.camera = SKNode()
        //self.camera?.name = cameraName
        self.world?.addChild(self.camera!)
        
        // UI setup
        self.overlay = SKNode()
        self.overlay?.zPosition = 10
        //self.overlay?.name = overlayName
        addChild(self.overlay!)
        
        let buttonSpacing: CGFloat = 60
        
        let tutorialButton = Button(caption: "Tutorial", scene: self, imageName: "LockedLevelIcon", functionToCall: tutorialButtonFunction)
        world?.addChild(tutorialButton)
        tutorialButton.position = CGPoint(x: 0, y: tutorialButton.backNode!.frame.height/2 + buttonSpacing/2)
        
        let testSceneButton = Button(caption: "Test Scene", scene: self, imageName: "LockedLevelIcon", functionToCall: testSceneButtonFunction)
        world?.addChild(testSceneButton)
        testSceneButton.position = CGPoint(x: 0, y: -(testSceneButton.backNode!.frame.height/2 + buttonSpacing/2))
        
        doorTransition = DoorTransition(type: .Horizontal, scene: self, initialState: .Open)
        world!.addChild(doorTransition!)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if let nodes: [SKNode] = nodesAtPoint(location) as? [SKNode] {
                for node in nodes {
                    if let button = node as? Button {
                        button.shouldBePressed = true
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            for object in self.children {
                if let button = object as? Button {
                    if button.containsPoint(location) == false {
                        button.shouldBePressed = false
                    }
                }
            }
            
            if let nodes: [SKNode] = nodesAtPoint(location) as? [SKNode] {
                for node in nodes {
                    if let button = node as? Button {
                        button.shouldExecute = true
                    }
                }
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        world!.enumerateChildNodesWithName("\(buttonName)*") {
            node, stop in
            let button = node as! Button
            button.update()
        }
    }
    
    func tutorialButtonFunction() {
        let doorTransitionDuration: NSTimeInterval = 0.5
        let actionTransitionSequence = SKAction.sequence([SKAction.runBlock({self.doorTransition?.closeDoors(doorTransitionDuration)}), SKAction.waitForDuration(doorTransitionDuration), SKAction.runBlock({self.transitionToTutorialScene()})])
        self.runAction(actionTransitionSequence)
    }
    
    func transitionToTutorialScene() {
        println("Transitioning Scene")
        if let scene = Tutorial.unarchiveFromFile("Tutorial") as? Tutorial {
            // Configure the view.
            let skView = self.view as SKView?
            skView?.showsFPS = false
            skView?.showsNodeCount = false
            skView?.showsPhysics = false
            
            println("Scene unarchived")
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView?.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.size = skView!.bounds.size
            
            //let transition = SKTransition.crossFadeWithDuration(1)
            
            //let actionRotate = SKAction.rotateToAngle(CGFloat(M_2_PI*2.5), duration: 0.5)
            
            let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
            //world!.runAction(SKAction.sequence([actionRotate, SKAction.runBlock({skView?.presentScene(scene, transition: transition)})]))
            skView?.presentScene(scene, transition: transition)
            
            
            //skView?.presentScene(scene, transition: transition)
        }
    }
    
    func testSceneButtonFunction() {
        let doorTransitionDuration: NSTimeInterval = 0.5
        let actionTransitionSequence = SKAction.sequence([SKAction.runBlock({self.doorTransition?.closeDoors(doorTransitionDuration)}), SKAction.waitForDuration(doorTransitionDuration), SKAction.runBlock({self.transitionToTestScene()})])
        self.runAction(actionTransitionSequence)
    }
    
    func transitionToTestScene() {
        println("Transitioning TO Test Scene")
        if let scene = TestScene.unarchiveFromFile("TestScene") as? TestScene {
            // Configure the view.
            let skView = self.view as SKView?
            skView?.showsFPS = false
            skView?.showsNodeCount = false
            skView?.showsPhysics = false
            
            println("Scene unarchived")
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView?.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.size = skView!.bounds.size
            
            let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
            
            skView?.presentScene(scene, transition: transition)
            
        }
    }
    
}