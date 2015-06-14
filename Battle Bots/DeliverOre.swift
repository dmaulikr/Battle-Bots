//
//  DeliverOre.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/14/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class DeliverOre: State {
    
    override var type: stateType? {
        get {return .DeliverOre}
        set {self.type = .DeliverOre}
    }
    
    override var priority: Int {
        get {return deliverOrePriority}
        set {self.priority = deliverOrePriority}
    }
    
    var HQ: Headquarters? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.HQ = nil
    }
    
    override func conditionsMet() -> Bool {
        if self.touchingStructureOfType(.Headquarters) == false {
            return false
        }
        else if self.hasOre() == false {
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
        if self.HQ == nil {
            self.findClosestHQ()
        }
        else if let miner = self.target as? Miner {
            miner.depositOre(self.HQ!)
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