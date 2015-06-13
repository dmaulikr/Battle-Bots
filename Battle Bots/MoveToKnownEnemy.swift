//
//  MoveToKnownEnemies.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MoveToKnownEnemy: State {
    
    override var type: stateType? {
        get {return .MoveToKnownEnemy}
        set {self.type = .MoveToKnownEnemy}
    }
    
    override var priority: Int {
        get {return moveToKnownEnemyPriority}
        set {self.priority = moveToKnownEnemyPriority}
    }
    
    let healthPercentThreshold: CGFloat = 0.50
    var closestEnemy: Mechanism? = nil
    var closestEnemyPosition: CGPoint? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestEnemy = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.healthGreaterThan(self.healthPercentThreshold) == false {
            return false
        }
        else if teamKnowsEnemyStructure() == false {
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
        if self.closestEnemy == nil {
            if let auto = self.target as? Auto {
                if findClosestEnemy() {
                    self.closestEnemyPosition = self.closestEnemy?.position
                    auto.moveTo(self.closestEnemy!.position, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
            }
        }
        else if getDistance(self.closestEnemyPosition!, self.closestEnemy!.position) >= 10 {
            self.closestEnemyPosition = self.closestEnemy?.position
            if let auto = self.target as? Auto {
                if findClosestEnemy() {
                    auto.moveTo(self.closestEnemy!.position, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
            }
        }
    }
    
    func findClosestEnemy() -> Bool {
        var knownEnemies: [Mechanism] = self.target!.team.knownEnemyAutos as [Mechanism] + self.target!.team.knownEnemyStructures as [Mechanism]
        
        if knownEnemies.isEmpty == false {
            if knownEnemies.count == 1 {
                self.closestEnemy = knownEnemies[0]
                return true
            }
            else {
                var distances = [CGFloat]()
                for enemy in knownEnemies {
                    distances.append(getDistance(self.target!.position, enemy.position))
                }
                self.closestEnemy = knownEnemies[find(distances,minElement(distances))!]
                return true
            }
        }
        else {
            return false
        }
    }
    
    
    
    
    
    
    
}