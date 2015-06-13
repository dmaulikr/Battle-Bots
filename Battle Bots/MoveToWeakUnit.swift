//
//  MoveToWeakUnit.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MoveToWeakUnit: State {
    
    override var type: stateType? {
        get {return .MoveToWeakUnit}
        set {self.type = .MoveToWeakUnit}
    }
    
    override var priority: Int {
        get {return moveToWeakUnitPriority}
        set {self.priority = moveToWeakUnitPriority}
    }
    
    var asset: Mechanism?
    var assetPosition: CGPoint?
    var healthPercentThreshold: CGFloat = 0.5
    var assetHealthPercentThreshold: CGFloat = 0.75
    
    
    override func deactivate() {
        super.deactivate()
        self.asset = nil
        self.assetPosition = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.teamMemberIsWeak(assetHealthPercentThreshold) == false {
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
                if let auto = self.target as? Auto {
                    auto.moveTo(self.assetPosition!, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
            }
        }
//        else if self.asset?.health == 0 {
//            setNewAsset()
//        }
        else if self.asset!.health / self.asset!.maxHealth >= self.assetHealthPercentThreshold {
            setNewAsset()
        }
        else if getDistance(self.assetPosition!, self.asset!.position) >= 10{
            self.assetPosition = self.asset?.position
            if let auto = self.target as? Auto {
                //auto.removeActionForKey(keyMoveTo)
                //auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
                auto.moveTo(self.assetPosition!, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
            }
        }
        
//        if self.asset != nil {
//            if self.asset?.health > 0 {
//                //Do Nothing
//            }
//            else {
//                println("Asset: \(self.asset?.name), Health: \(self.asset?.health)")
//                fatalError("Found the Bug. Asset has been removed yet is still set as medic asset")
//            }
//        }

    }
    
    func setNewAsset() -> Bool {
        var potentialAssets: [Mechanism] = []
        for mechanism in self.target!.team.mechanisms {
            if self.target != mechanism {
                if mechanism.health / mechanism.maxHealth <= self.assetHealthPercentThreshold && mechanism.health > 0 {
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
            self.assetPosition = self.asset?.position
            return true
        }
        else {
            self.asset = nil
            return false
        }
        
    }
    
}