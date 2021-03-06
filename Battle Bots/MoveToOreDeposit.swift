//
//  MoveToOreDeposit.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/13/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MoveToOreDeposit: State {
    
    override var type: stateType? {
        get {return .MoveToOreDeposit}
        set {self.type = .MoveToOreDeposit}
    }
    
    override var priority: Int {
        get {return moveToOreDepositPriority}
        set {self.priority = moveToOreDepositPriority}
    }

    var closestOreDeposit: OreDeposit? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestOreDeposit = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if teamKnowsOreDeposit() == false {
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
        if self.closestOreDeposit == nil {
            if let auto = self.target as? Auto {
                if findClosestOreDeposit() {
                    auto.moveTo(self.closestOreDeposit!.position, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
            }
        }
    }
    
    func findClosestOreDeposit() -> Bool {
        
        let knownOreDeposits = self.target!.team.knownOreDeposits
        
        if knownOreDeposits.isEmpty == false {
            if knownOreDeposits.count == 1 {
                self.closestOreDeposit = knownOreDeposits[0]
                return true
            }
            else {
                var distances = [CGFloat]()
                for deposit in knownOreDeposits {
                    distances.append(getDistance(self.target!.position, deposit.position))
                }
                self.closestOreDeposit = knownOreDeposits[find(distances,minElement(distances))!]
                return true
            }
        }
        else {
            return false
        }
    }

    
}