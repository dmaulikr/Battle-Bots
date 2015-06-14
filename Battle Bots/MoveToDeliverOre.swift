//
//  DeliverOre.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/14/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MoveToDeliverOre: State {
    
    override var type: stateType? {
        get {return .MoveToDeliverOre}
        set {self.type = .MoveToDeliverOre}
    }
    
    override var priority: Int {
        get {return moveToDeliverOrePriority}
        set {self.priority = moveToDeliverOrePriority}
    }
    
    var HQ: Headquarters?
    
    override func deactivate() {
        super.deactivate()
        self.HQ = nil
        if let auto = self.target as? Auto {
            auto.removeActionForKey(keyMoveTo)
            auto.bodyNode.removeActionForKey(keyRotateTowardsPoint)
        }
    }
    
    override func conditionsMet() -> Bool {
        if self.target!.team.headquarters.isEmpty {
            return false
        }
        else if hasOre() == false {
            return false
        }
        else if canCarryMoreOre() && teamKnowsOreDeposit(){
            return false
        }
        else {
            return true
        }
    }
    
    override func canBeActive() -> Bool {
        if let auto = self.target as? Auto {
            return conditionsMet()
        }
        else {
            return false
        }
    }
    
    override func run() {
        if self.HQ == nil {
            if self.findClosestHQ() {
                if let auto = self.target as? Auto {
                    auto.moveTo(self.HQ!.position, speed: auto.baseSpeed!, rotateSpeed: auto.baseRotateSpeed!)
                }
            }
        }
    }
    
    func findClosestHQ() -> Bool {
        if self.target?.team.headquarters.isEmpty == false {
            var distances = [CGFloat]()
            for HQ in self.target!.team.headquarters {
                let distance = getDistance(HQ.position, self.target!.position)
                distances.append(distance)
            }
            self.HQ = self.target?.team.headquarters[find(distances, minElement(distances))!]
            return true
        }
        return false
    }
    
}