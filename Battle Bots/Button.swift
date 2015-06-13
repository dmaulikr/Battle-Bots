//
//  Button.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/4/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

enum buttonType {
    case Text
    case ImageAndCaption
}

let buttonName = "button"

class Button: SKNode {
    
    override var name: String? {
        get{return buttonName}
        set{self.name = buttonName}
    }
    
    var type: buttonType
    var labelNode: SKLabelNode?
    var imageNode: SKSpriteNode?
    var backNode: SKShapeNode?
    
    var functionToCall: (Void) -> Void
    
    var shouldBePressed = false
    var isPressed = false
    var shouldExecute = false
    var hasExecuted = false
    
    init(text: String, scene: SKScene, functionToCall: (Void) -> Void) {
        self.type = .Text
        self.functionToCall = functionToCall
        
        super.init()
        
        self.backNode = SKShapeNode(rectOfSize: CGSize(width: scene.view!.bounds.width/1.1, height: scene.view!.bounds.height/8), cornerRadius: scene.view!.bounds.width/40)
        self.backNode?.fillColor = SKColor.lightGrayColor()
        self.backNode?.strokeColor = SKColor.darkGrayColor()
        
        self.labelNode = SKLabelNode(fontNamed: primaryFont)
        self.labelNode?.text = text
        self.labelNode?.fontColor = SKColor.darkGrayColor()
        self.labelNode?.fontSize = self.backNode!.frame.height/1.4
        self.labelNode?.verticalAlignmentMode = .Top
        self.labelNode?.position = CGPoint(x: 0, y: self.labelNode!.fontSize/2.1)
        
        self.addChild(backNode!)
        self.addChild(labelNode!)
    }
    
    init(caption: String, scene:SKScene, imageName: String, functionToCall: (Void) -> Void) {
        self.type = .ImageAndCaption
        self.functionToCall = functionToCall
        
        super.init()
        
        self.imageNode = SKSpriteNode(imageNamed: imageName)
        self.imageNode?.setScale(0.25)
        
        self.backNode = SKShapeNode(rectOfSize: CGSize(width: self.imageNode!.size.width + 20, height: self.imageNode!.size.height + 20), cornerRadius: 2)
        self.backNode?.fillColor = SKColor.lightGrayColor()
        self.backNode?.strokeColor = SKColor.darkGrayColor()
        
        self.labelNode = SKLabelNode(fontNamed: primaryFont)
        self.labelNode?.text = caption
        self.labelNode?.fontColor = SKColor.darkGrayColor()
        self.labelNode?.fontSize = backNode!.frame.height/4
        self.labelNode?.verticalAlignmentMode = .Top
        self.labelNode?.position = CGPoint(x: 0, y: -self.backNode!.frame.height/2)
        
        self.addChild(backNode!)
        self.addChild(imageNode!)
        self.addChild(labelNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pressDown() {
        self.backNode?.fillColor = SKColor.darkGrayColor()
        if self.type == .Text {
            self.labelNode?.fontColor = SKColor.whiteColor()
        }
        let actionPressDown = SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.2), SKAction.runBlock({self.isPressed = true})])
        self.runAction(actionPressDown, withKey: keyButtonPress)
    }
    
    func pressUp() {
        self.backNode?.fillColor = SKColor.lightGrayColor()
        if self.type == .Text {
            self.labelNode?.fontColor = SKColor.darkGrayColor()
        }
        let actionPressUp = SKAction.sequence([SKAction.scaleTo(1.0, duration: 0.2), SKAction.runBlock({self.isPressed = false})])
        self.runAction(actionPressUp, withKey: keyButtonPress)
    }
    
    func pressUpAndExecute() {
        self.isPressed = false
        self.backNode?.fillColor = SKColor.lightGrayColor()
        if self.type == .Text {
            self.labelNode?.fontColor = SKColor.darkGrayColor()
        }
        let actionPressUp = SKAction.sequence([SKAction.scaleTo(1.0, duration: 0.2), SKAction.runBlock({self.isPressed = false})])
        let actionUpAndExecute = SKAction.sequence([actionPressUp ,SKAction.runBlock({self.executeFunction()})])
        self.runAction(actionUpAndExecute, withKey: keyButtonPress)
    }
    
    func executeFunction() {
        self.hasExecuted = true
        self.functionToCall()
    }
    
    func update() {
        if self.actionForKey(keyButtonPress) == nil && self.hasExecuted == false {
            if shouldBePressed && isPressed == false && shouldExecute == false {
                self.pressDown()
            }
            else if shouldBePressed == false && isPressed && shouldExecute == false {
                self.pressUp()
            }
            else if shouldExecute && isPressed == false{
                self.pressDown()
            }
            else if shouldExecute && isPressed == true{
                self.pressUpAndExecute()
            }
        }
    }
    
}