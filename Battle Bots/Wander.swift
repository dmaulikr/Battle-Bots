//
//  Wander.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Wander: State {
    
    override var type: stateType? {
        get {return .Wander}
        set {self.type = .Wander}
    }
    
    override var priority: Int {
        get {return wanderPriority}
        set {self.priority = wanderPriority}
    }
    
    var range: Int = 200
    var destination: CGPoint?
    var healthPercentThreshold: CGFloat = 0.2
    
    
    override func deactivate() {
        super.deactivate()
        self.destination = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.healthGreaterThan(healthPercentThreshold) == false {
            return false
        }
        else {
            return true
        }
    }
    
    override func canBeActive() -> Bool {
        println("Checking Wander State")
        if target?.mechType == .Auto {
            return conditionsMet()
        }
        else {
            return false
        }
    }
    
    override func run() {
        
        if self.destination == nil {
            setNewDestination()
            if let auto = self.target as? Auto {
                auto.moveTo(self.destination!, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
            }
        }
        else if getDistance(self.target!.position, self.destination!) <= 1 {
            self.destination = nil
        }
    }
    
    func setNewDestination() {
        if self.target != nil {
            do {
                self.destination = getPointWithinRange(self.range, self.target!.position)
            }
            while self.target?.world.boundary?.containsPosition(self.destination!) == false
        }
    }
    
    
}