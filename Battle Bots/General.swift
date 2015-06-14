//
//  General.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/28/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

//Fonts
let primaryFont = "Ariel"
let secondaryFont = ""
let tertiaryFont = ""

//Scales
let autosScale:CGFloat = 0.25
let structuresScale: CGFloat = 0.5
let doorTransitionScale: CGFloat = 0.75
//OreScales
let oreScaleSmall:CGFloat = 0.2
let oreScaleMedium:CGFloat = 0.4
let oreScaleLarge:CGFloat = 0.5
let oreScaleHuge:CGFloat = 0.75

//Colors
let sightNodeFillColor = SKColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.05)
let sightNodeStrokeColor = SKColor.grayColor()

let colorHeal = SKColor.greenColor()
let colorRecharge = SKColor.yellowColor()
let colorMenuBackground = SKColor(red: 220/255, green: 210/255, blue: 180/255, alpha: 1.0)

//SKActions
let repairDuration: NSTimeInterval = 0.5
let rechargeDuration: NSTimeInterval = 0.5

let actionButtonPress = SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.2),SKAction.scaleTo(1.0, duration: 0.2)])
let actionRotateDish = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_2_PI), duration: 0.5))
let actionRepairAuto = SKAction.sequence([SKAction.group([SKAction.colorizeWithColor(colorHeal, colorBlendFactor: 0.5, duration: repairDuration/2), SKAction.scaleTo(1.1, duration: repairDuration/2)]),SKAction.group([SKAction.colorizeWithColor(colorHeal, colorBlendFactor: 0.0, duration: repairDuration/2), SKAction.scaleTo(1.0, duration: repairDuration/2)])])
let actionRepairStructure = SKAction.sequence([SKAction.group([SKAction.scaleTo(1.05, duration: repairDuration/2)]),SKAction.group([SKAction.scaleTo(1.0, duration: repairDuration/2)])])
let actionTakeDamage = SKAction.sequence([SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 0.2),SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.0, duration: 0.2)])
let actionRechargeAuto = SKAction.sequence([SKAction.group([SKAction.colorizeWithColor(colorRecharge, colorBlendFactor: 0.5, duration: rechargeDuration/2), SKAction.scaleTo(1.1, duration: rechargeDuration/2)]),SKAction.group([SKAction.colorizeWithColor(colorRecharge, colorBlendFactor: 0.0, duration: rechargeDuration/2), SKAction.scaleTo(1.0, duration: rechargeDuration/2)])])


//Action Keys
let keyButtonPress = "buttonPress"
let keyRotateDish = "rotateDish"
let keyRotateTowardsPoint = "rotateTowardsPoint"
let keyMoveTo = "moveTo"
let keyRepair = "repair"
let keyBulletFiring = "bulletFiring"
let keyExplosionFade = "explosionFade"
let keyRecharge = "recharge"
let keyTakeDamage = "takeDamage"

//Strings and Names
let mechanismName = "mechanism"

//Enum

enum doorType {
    case Horizontal
    case Vertical
}

enum doorState {
    case Closed
    case Open
}

enum oreSize {
    case Small
    case Medium
    case Large
    case Huge
}

enum projectileType {
    case MediumBullet
    case SmallBullet
    case Rocket
}

enum teamType {
    case Neutral
    case Player
    case Friendly
    case Enemy
}

enum autoType {
    case Default
    case Scout
    case Miner
    case Medic
    case LightArmor
    case MachineGunner
    case ScatterShot
    case Artillery
    case Engineer
}

enum structureType {
    case Default
    case Headquarters
    case RepairStation
    case ChargingStation
    
    case BulletGuardTurret
}

enum physicsCategory: UInt32 {
    case None = 1
    case Auto = 2
    case Structure = 4
    case Projectile = 8
    case Sight = 16
    case Explosion = 32
    case Ore = 64
    //case Shield = 128
}

//enum physicsCategory: UInt32 {
//    case None = 0
//    case Auto = 0b0000001
//    case Structure = 0b0000010
//    case Projectile = 0b0000100
//    case Sight = 0b0001000
//    case Explosion = 0b0010000
//    case Ore = 0b0100000
//    case Shield = 0b1000000
//}

enum healthBarType {
    case Structure
    case Auto
    case GuardTurret
}

enum mechanismType {
    case Structure
    case Auto
}

enum stateType {
    case Wander
    case Guard
    case NeedCharge
    case Recharge
    case NeedRepair
    case Repairing
    case Attack
    case MoveToKnownEnemy
    case MoveToWeakUnit
    case RepairUnit
    case MoveToHQ
    case MoveToOreDeposit
    case MineOre
    case MoveToDeliverOre
    case DeliverOre
    
    case BuildAutos
}

//State Priorities
let defaultPriority: Int = 0
let wanderPriority: Int = 16
let guardPriority: Int = 14
let needChargePriority: Int = 8
let rechargePriority: Int = 7
let needRepairPriority: Int = 11
let repairingPriority: Int = 10
let attackingPriority: Int = 9
let moveToKnownEnemyPriority: Int = 15
let moveToWeakUnitPriority: Int = 13
let repairUnitPriority: Int = 12
let moveToHQPriority:Int = 21
let moveToOreDepositPriority: Int = 20
let mineOrePriority: Int = 17
let moveToDeliverOrePriority: Int = 19
let deliverOrePriority: Int = 18

let buildAutosPriority: Int = 1

//Functions
func rotateNodeTowardsPoint(node: SKNode, point: CGPoint, speed: CGFloat) {
    let actionToRotate = getActionRotateNodeTowardsPoint(node, point, speed)
    node.runAction(actionToRotate, withKey: keyRotateTowardsPoint)
}

func getActionRotateNodeTowardsPoint(node: SKNode, point: CGPoint, speed: CGFloat) -> SKAction {
    var newAngle = CGFloat()
    newAngle = CGFloat(atan2f(Float(node.position.y - point.y),Float(node.position.x - point.x))) + CGFloat(M_PI_2)
    if newAngle >= CGFloat(M_PI) {
        newAngle -= CGFloat(M_PI)*2
    }
    let angularDistance = newAngle - node.zRotation
    let angularDuration: NSTimeInterval = NSTimeInterval(CGFloat(abs(angularDistance)) / speed)
    return SKAction.rotateToAngle(newAngle, duration: angularDuration)
}

func getDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let xDist: CGFloat = (point2.x - point1.x)
    let yDist: CGFloat = (point2.y - point1.y)
    let distance: CGFloat = sqrt((xDist * xDist) + (yDist * yDist))
    return distance
}

func getRandomInt(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func getPointWithinRange(range: Int, ofPoint: CGPoint) -> CGPoint {
    //Currently chooses a random point from within a square that has a center of the point and sides of 2 * range.
    let randX = ofPoint.x + CGFloat(getRandomInt(-range, range))
    let randY = ofPoint.y + CGFloat(getRandomInt(-range, range))
    let randomPoint = CGPoint(x: randX, y: randY)
    return randomPoint
}

func getOreCostOfAutoType(type: autoType) -> CGFloat {
    switch type {
    case .LightArmor:
        return lightArmorOreCost
    case .Scout:
        return scoutOreCost
    case .MachineGunner:
        return machineGunnerOreCost
    case .ScatterShot:
        return scatterShotOreCost
    case .Miner:
        return minerOreCost
    case .Medic:
        return medicOreCost
    case .Artillery:
        return artilleryOreCost
    default:
        fatalError("ERROR: Unknown autoType '\(type)' in 'getOreCostOfAutoType'")
    }
}

func makeAuto(world: World, team: Team, position: CGPoint, type: autoType) {
    var auto: Auto?
    switch type {
    case .Artillery:
        auto = Artillery(team: team, world: world)
    case .MachineGunner:
        auto = MachineGunner(team: team, world: world)
    case .LightArmor:
        auto = LightArmor(team: team, world: world)
    case .ScatterShot:
        auto = ScatterShot(team: team, world: world)
    case .Scout:
        auto = Scout(team: team, world: world)
    case .Miner:
        auto = Miner(team: team, world: world)
    case .Medic:
        auto = Medic(team: team, world: world)
    default:
        fatalError("ERROR: Unknown autoType '\(type)' in 'makeAuto' function")
    }
    
    auto?.position = position
    auto?.doAdditionalSetUp()
    world.addChild(auto!)
}

















