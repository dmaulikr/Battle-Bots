//
//  Mechanism.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Mechanism: SKNode {
    
    var world: World
    var health: CGFloat = 100
    var maxHealth: CGFloat = 100
    var team: Team
    var fsm: FSM? = nil
    var mechType: mechanismType? = nil
    
    var oreCost: CGFloat?
    
    var guards = [Mechanism]()
    var maxGuardPositions: Int = 4
    
    var structuresInContactWith = [Structure]()
    var autosInContactWith = [Auto]()
    
    var enemyStructuresInContactWith = [Structure]()
    var enemyAutosInContactWith = [Auto]()
    
    var enemyStructuresInSight = [Structure]()
    var enemyAutosInSight = [Auto]()
    
    var sightNode: SKShapeNode?
    
    init(team: Team, world: World) {
        
        self.team = team
        self.world = world
        
        super.init()
        
        self.name = mechanismName
    }
    
    override init() {
        self.team = Team()
        self.world = World()
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        //Customized for each mechanism
        if self.health <= 0 {
            self.destroy()
        }
        self.doLogic()
    }
    
    func removeFromArrays() {
        self.world.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            if let mechanism = node as? Mechanism {
                mechanism.didLoseSightOfMechanism(self)
                mechanism.didEndCollisionWithMechanism(self)
                mechanism.team.removeEnemyMechanism(self)
            }
        }
    }
    
    func destroy() {
        self.removeFromArrays()
        self.team.remove(self)
        self.removeFromParent()
    }
    
    func doLogic() {
        self.fsm!.update()
    }
    
    func repair(amount: CGFloat) {
        self.health += amount
        if self.health > self.maxHealth {
            self.health = self.maxHealth
        }
    }
    
    func didSpotMechanism(mechanism: Mechanism) {
        if mechanism.team.name != self.team.name {
            self.team.addEnemyMechanism(mechanism)
            switch mechanism.mechType! {
            case .Structure:
                let structure = mechanism as! Structure
                if contains(self.enemyStructuresInSight, structure) == false {
                    self.enemyStructuresInSight.append(structure)
                }
            case .Auto:
                let auto = mechanism as! Auto
                if contains(self.enemyAutosInSight, auto) == false {
                    self.enemyAutosInSight.append(auto)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'didLoseSightOfMechanism' method")
            }
        }
    }
    
    func didLoseSightOfMechanism(mechanism: Mechanism) {
        if mechanism.team.name != self.team.name {
            switch mechanism.mechType! {
            case .Structure:
                let structure = mechanism as! Structure
                if contains(self.enemyStructuresInSight, structure) {
                    self.enemyStructuresInSight.removeAtIndex(find(self.enemyStructuresInSight, structure)!)
                }
            case .Auto:
                let auto = mechanism as! Auto
                if contains(self.enemyAutosInSight, auto) {
                    self.enemyAutosInSight.removeAtIndex(find(self.enemyAutosInSight, auto)!)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'didLoseSightOfMechanism' method")
            }
        }
    }
    
    func didCollideWithMechanism(mechanism: Mechanism) {
        
        if mechanism.team.name == self.team.name {
            switch mechanism.mechType! {
            case .Structure:
                if contains(self.structuresInContactWith, mechanism as! Structure) == false {
                    self.structuresInContactWith.append(mechanism as! Structure)
                }
            case .Auto:
                if contains(self.autosInContactWith, mechanism as! Auto) == false {
                    self.autosInContactWith.append(mechanism as! Auto)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'didCollideWithMechanism()' for the mechanism '\(mechanism.name)'")
            }
        }
        else {
            switch mechanism.mechType! {
            case .Structure:
                if contains(self.enemyStructuresInContactWith, mechanism as! Structure) == false {
                    self.enemyStructuresInContactWith.append(mechanism as! Structure)
                }
            case .Auto:
                if contains(self.enemyAutosInContactWith, mechanism as! Auto) == false {
                    self.enemyAutosInContactWith.append(mechanism as! Auto)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'didCollideWithMechanism()' for the mechanism '\(mechanism.name)'")
            }
        }
    }
    
    func didEndCollisionWithMechanism(mechanism: Mechanism) {
        
        if mechanism.team.name == self.team.name {
            switch mechanism.mechType! {
            case .Structure:
                if contains(self.structuresInContactWith, mechanism as! Structure) {
                    self.structuresInContactWith.removeAtIndex(find(self.structuresInContactWith, mechanism as! Structure)!)
                }
            case .Auto:
                if contains(self.autosInContactWith, mechanism as! Auto) {
                    self.autosInContactWith.removeAtIndex(find(self.autosInContactWith, mechanism as! Auto)!)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'didEndCollisionWithMechanism()' for the mechanism '\(mechanism.name)'")
            }
        }
        else {
            switch mechanism.mechType! {
            case .Structure:
                if contains(self.enemyStructuresInContactWith, mechanism as! Structure) {
                    self.enemyStructuresInContactWith.removeAtIndex(find(self.enemyStructuresInContactWith, mechanism as! Structure)!)
                }
            case .Auto:
                if contains(self.enemyAutosInContactWith, mechanism as! Auto) {
                    self.enemyAutosInContactWith.removeAtIndex(find(self.enemyAutosInContactWith, mechanism as! Auto)!)
                }
            default:
                fatalError("ERROR: Unknown mechType '\(mechanism.mechType)' in 'didEndCollisionWithMechanism()' for the mechanism '\(mechanism.name)'")
            }
        }
        
    }
    
    func takeDamage(amount: CGFloat) {
        self.health -= amount
        if self.health < 0 {
            self.health = 0
        }
    }
    
    func addGuard(mechanism: Mechanism) {
        if self.guards.count < self.maxGuardPositions {
            self.guards.append(mechanism)
        }
    }
    
    func removeGuard(mechanism: Mechanism) {
        if contains(self.guards, mechanism) {
            self.guards.removeAtIndex(find(self.guards, mechanism)!)
        }
    }
    
    func doAdditionalSetUp() {
        //Sets up the team and fsm of the mechanism
        self.addToTeam()
        self.fsm?.setNewTarget(self)
        if self.sightNode != nil {
            self.sightNode?.hidden = true
        }
    }
    
    func addToTeam() {
        self.team.add(self)
    }
}