//
//  HealthBar.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar: SKNode {
    var healthAsPercent: CGFloat = 1
    var energyAsPercent: CGFloat = 1
    var type: healthBarType
    
    var healthNode: SKShapeNode
    var energyNode: SKShapeNode? = nil
    var backNode: SKShapeNode
    
    init(type: healthBarType) {
        
        switch type {
        case .Structure:
            self.healthNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 8)), cornerRadius: 1)
            self.backNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: -4, y: -4), size: CGSize(width: 110, height: 16)), cornerRadius: 1)
            self.type = .Structure
        case .GuardTurret:
            self.healthNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 4, y: -2), size: CGSize(width: 30, height: 4)), cornerRadius: 1)
            self.backNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: -4), size: CGSize(width: 38, height: 8)), cornerRadius: 1)
            self.type = .GuardTurret
        case .Auto:
            let backNodeMargin:CGFloat = 1
            self.healthNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 2)), cornerRadius: 1)
            self.energyNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 20, height: 2)), cornerRadius: 1)
            self.backNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: -backNodeMargin, y: -2), size: CGSize(width: healthNode.frame.width + backNodeMargin, height: healthNode.frame.height + 2*backNodeMargin + 1)), cornerRadius: 0)
            self.type = .Auto
            
            self.energyNode!.fillColor = SKColor.blueColor()
            self.energyNode!.strokeColor = SKColor.clearColor()
            self.energyNode!.zPosition = 11
            
            self.healthNode.position = CGPoint(x: 0, y: healthNode.frame.height/2)
            self.energyNode!.position = CGPoint(x: 0, y: -energyNode!.frame.height/2)
            
        default:
            fatalError("Error: Unknown health bar type: \(type)")
        }
        self.healthNode.fillColor = SKColor.greenColor()
        self.healthNode.strokeColor = SKColor.clearColor()
        self.healthNode.zPosition = 11
        
        self.backNode.fillColor = SKColor.lightGrayColor()
        self.backNode.strokeColor = SKColor.clearColor()
        self.backNode.zPosition = 10.5
        
        super.init()
        
        self.alpha = 0.5
        
        if self.type == .Auto {
            self.addChild(energyNode!)
        }
        
        backNode.addChild(healthNode)
        self.addChild(backNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(health: CGFloat, maxHealth: CGFloat) {
        switch self.type {
        case .Structure:
            self.position = CGPoint(x: -self.backNode.frame.width/2, y: 80)
        case .Auto:
            self.position = CGPoint(x: -self.backNode.frame.width/2, y: 20)
        case .GuardTurret:
            self.position = CGPoint(x: -self.backNode.frame.width/2, y: 30)
        default:
            fatalError("Error: Unknown health bar type: \(self.type)")
        }
        self.healthAsPercent = health/maxHealth
        healthNode.xScale = self.healthAsPercent
        
        switch self.healthAsPercent*100{
        case 50...100:
            self.healthNode.fillColor = SKColor.greenColor()
        case 25...50:
            self.healthNode.fillColor = SKColor.yellowColor()
        case 0...25:
            self.healthNode.fillColor = SKColor.redColor()
        default:
            fatalError("Error: Health bar percentage \(self.healthAsPercent)")
        }
    }
    
    func update(health: CGFloat, maxHealth: CGFloat, energy: CGFloat, maxEnergy: CGFloat) {
        switch self.type {
        case .Structure:
            self.position = CGPoint(x: -self.backNode.frame.width/2, y: 80)
        case .Auto:
            self.position = CGPoint(x: -self.backNode.frame.width/2, y: 20)
        case .GuardTurret:
            self.position = CGPoint(x: -self.backNode.frame.width/2, y: 30)
        default:
            fatalError("Error: Unknown health bar type: \(self.type)")
        }
        self.healthAsPercent = health/maxHealth
        healthNode.xScale = self.healthAsPercent
        
        self.energyAsPercent = energy/maxEnergy
        energyNode?.xScale = self.energyAsPercent
        
        switch self.healthAsPercent*100{
        case 50...100:
            self.healthNode.fillColor = SKColor.greenColor()
        case 25...50:
            self.healthNode.fillColor = SKColor.yellowColor()
        case 0...25:
            self.healthNode.fillColor = SKColor.redColor()
        default:
            fatalError("Error: Health bar percentage \(self.healthAsPercent)")
        }
    }

    
    
}