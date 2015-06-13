//
//  MenuScene.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/28/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    let buttonSpacing: CGFloat = 20
    
    var doorTransition: DoorTransition?
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = colorMenuBackground
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let storyButton = Button(text: "Play", scene: self, functionToCall: storyButtonFunction)
        self.addChild(storyButton)
        
        let arenaButton = Button(text: "Arena", scene: self, functionToCall: transitionToArenaScene)
        arenaButton.position = CGPoint(x: 0, y: storyButton.position.y - (storyButton.backNode!.frame.height + self.buttonSpacing))
        self.addChild(arenaButton)
        
        let aboutButton = Button(text: "About", scene: self, functionToCall: transitionToAboutScene)
        aboutButton.position = CGPoint(x: 0, y: arenaButton.position.y - (arenaButton.backNode!.frame.height + self.buttonSpacing))
        self.addChild(aboutButton)
        
        doorTransition = DoorTransition(type: .Vertical, scene: self, initialState: .Closed)
        self.addChild(doorTransition!)
        
        let actionReveal = SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.runBlock({self.doorTransition!.openDoors(0.5)})])
        self.runAction(actionReveal)
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
                        button.shouldBePressed = false
                    }
                }
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        self.enumerateChildNodesWithName("\(buttonName)*") {
            node, stop in
            let button = node as! Button
            button.update()
        }
    }
    
    func storyButtonFunction() {
        let doorTransitionDuration: NSTimeInterval = 0.5
        let actionTransitionSequence = SKAction.sequence([SKAction.runBlock({self.doorTransition?.closeDoors(doorTransitionDuration)}), SKAction.waitForDuration(doorTransitionDuration), SKAction.runBlock({self.transitionToLevelSelectScene()})])
        self.runAction(actionTransitionSequence)
    }
    
    
    
    
    func transitionToLevelSelectScene() {
        println("Transitioning Scene")
        if let scene = LevelSelectScene.unarchiveFromFile("LevelSelectScene") as? LevelSelectScene {
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
            
            let transition = SKTransition.doorsOpenVerticalWithDuration(0.5)
            
            skView?.presentScene(scene, transition: transition)
        }
    }
    
    func transitionToArenaScene() {
        
    }
    
    func transitionToAboutScene() {
        
    }
    
}