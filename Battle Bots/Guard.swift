//
//  Guard.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/1/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Guard: State {
    
    override var type: stateType? {
        get {return .Guard}
        set {self.type = .Guard}
    }
    
    override var priority: Int {
        get {return guardPriority}
        set {self.priority = guardPriority}
    }
    
    var asset: Mechanism?
    var assetPosition: CGPoint?
    var guardRoute: [CGPoint] = []
    var healthPercentThreshold: CGFloat = 0.5
    var assetHealthPercentThreshold: CGFloat = 0.2
    var autoGuardRadius: CGFloat = 30.0
    var structureGuardRadius: CGFloat = 100.0
    
    
    override func deactivate() {
        super.deactivate()
        self.assetPosition = nil
        if self.asset != nil {
            if contains(self.asset!.guards, self.target!) {
                self.asset?.removeGuard(self.target!)
                self.asset = nil
            }
        }
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.healthGreaterThan(healthPercentThreshold) == false {
            return false
        }
        else if self.teamMemberIsWeakAndAcceptsGuards(assetHealthPercentThreshold) == false {
            return false
        }
        else {
            return true
        }
    }
    
    override func canBeActive() -> Bool {
        if target?.mechType == .Auto {
            return conditionsMet()
        }
        else {
            return false
        }
    }
    
    override func run() {
        if self.asset == nil {
            if setNewAsset() {
                moveToGuardPosition(self.target!)
            }
        }
        else {
            if getDistance(self.asset!.position, self.assetPosition!) >= 20 {
                moveToGuardPosition(self.target!)
            }
            if self.asset!.health / self.asset!.maxHealth >= self.assetHealthPercentThreshold {
                self.asset?.removeGuard(self.target!)
                setNewAsset()
            }
        }
    }
    
    func setNewAsset() -> Bool {
        var potentialAssets: [Mechanism] = []
        for mechanism in self.target!.team.mechanisms {
            if self.target != mechanism {
                if mechanism.health / mechanism.maxHealth <= self.assetHealthPercentThreshold {
                    potentialAssets.append(mechanism)
                }
            }
        }
        if potentialAssets.isEmpty == false {
            var distanceToPotentialAssets: [CGFloat] = []
            for asset in potentialAssets {
                let distance = getDistance(self.target!.position, asset.position)
                distanceToPotentialAssets.append(distance)
            }
            self.asset = potentialAssets[find(distanceToPotentialAssets,minElement(distanceToPotentialAssets))!]
            return true
        }
        else {
            self.asset = nil
            return false
        }
        
    }
    
    func moveToGuardPosition(guard: Mechanism) {
        if contains(self.asset!.guards, self.target!) == false {
            self.asset?.addGuard(self.target!)
        }
        if let auto = guard as? Auto {
            self.assetPosition = self.asset?.position
            var guardRadius: CGFloat?
            switch self.asset!.mechType! {
            case .Auto:
                guardRadius = self.autoGuardRadius
            case .Structure:
                guardRadius = self.structureGuardRadius
            default:
                fatalError("ERROR: Unknown mechType \(self.asset!.mechType!)")
            }
            var targetPosition: CGPoint?
            switch find(self.asset!.guards, self.target!)!+1 {
            case 1:
                targetPosition = CGPoint(x: self.assetPosition!.x + guardRadius!, y: self.assetPosition!.y)
            case 2:
                targetPosition = CGPoint(x: self.assetPosition!.x - guardRadius!, y: self.assetPosition!.y)
            case 3:
                targetPosition = CGPoint(x: self.assetPosition!.x, y: self.assetPosition!.y + guardRadius!)
            case 4:
                targetPosition = CGPoint(x: self.assetPosition!.x, y: self.assetPosition!.y - guardRadius!)
            default:
                targetPosition = self.assetPosition
            }
            println("MOVING TO GUARD POSITION")
            println(targetPosition!)
            auto.moveTo(targetPosition!, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
        }
    }

    
    
    
}