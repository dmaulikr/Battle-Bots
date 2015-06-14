//
//  MineOre.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/14/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MineOre: State {
    
    override var type: stateType? {
        get {return .MineOre}
        set {self.type = .MineOre}
    }
    
    override var priority: Int {
        get {return mineOrePriority}
        set {self.priority = mineOrePriority}
    }
    
    var closestOreDeposit: OreDeposit? = nil
    
    
    override func deactivate() {
        super.deactivate()
        self.closestOreDeposit = nil
    }
    
    override func conditionsMet() -> Bool {
        if self.touchingOreDeposit() == false {
            return false
        }
        else if self.canCarryMoreOre() == false {
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
            self.findClosestOreDeposit()
        }
        else if let miner = self.target as? Miner {
            if miner.oreAmount < miner.oreMaxCapacity {
                miner.mine(self.closestOreDeposit!)
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