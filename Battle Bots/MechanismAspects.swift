//
//  MechanismAspects.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/29/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

//AUTOS
let autoMaxGuardPostitions: Int = 2

//Engineer
let engineerOreCost: CGFloat = 200
let engineerHealth: CGFloat = 20
let engineerEnergy: CGFloat = 100
let engineerSightRadius: CGFloat = 50
let engineerBaseSpeed: CGFloat = 50
let engineerBaseRotateSpeed: CGFloat = 2
let engineerToolRotateSpeed: CGFloat = 2
let engineerStates: [stateType] = [.Wander, .NeedRepair, .Repairing, .NeedCharge, .Recharge]

//Scout
let scoutOreCost: CGFloat = 50
let scoutHealth: CGFloat = 20
let scoutEnergy: CGFloat = 100
let scoutSightRadius: CGFloat = 200
let scoutBaseSpeed: CGFloat = 75
let scoutBaseRotateSpeed: CGFloat = 3
let scoutStates: [stateType] = [.Wander, .NeedRepair, .Repairing, .NeedCharge, .Recharge]

//Miner
let minerOreCost: CGFloat = 75
let minerHealth: CGFloat = 20
let minerEnergy: CGFloat = 100
let minerSightRadius: CGFloat = 200
let minerBaseSpeed: CGFloat = 75
let minerBaseRotateSpeed: CGFloat = 3
let minerMineAmount: CGFloat = 50
let minerOreMaxCapacity: CGFloat = 150
let minerStates: [stateType] = [.MoveToHQ, .MoveToDeliverOre, .DeliverOre, .MoveToOreDeposit, .MineOre, .NeedRepair, .Repairing, .NeedCharge, .Recharge]


//Medic
let medicOreCost: CGFloat = 200
let medicHealth: CGFloat = 10
let medicEnergy: CGFloat = 200
let medicSightRadius: CGFloat = 100
let medicBaseSpeed: CGFloat = 100
let medicBaseRotateSpeed: CGFloat = 5
let medicRepairAmount: CGFloat = 5
let medicStates: [stateType] = [.MoveToHQ, .NeedRepair, .Repairing, .NeedCharge, .Recharge, .MoveToWeakUnit, .RepairUnit]


//LightArmor
let lightArmorOreCost: CGFloat = 100
let lightArmorHealth: CGFloat = 40
let lightArmorEnergy: CGFloat = 100
let lightArmorSightRadius: CGFloat = 120
let lightArmorBaseSpeed: CGFloat = 50
let lightArmorBaseRotateSpeed: CGFloat = 2
let lightArmorTurretRotateSpeed: CGFloat = 2
let lightArmorStates: [stateType] = [.Wander, .NeedRepair, .Repairing, .Attack, .NeedCharge, .Recharge, .MoveToKnownEnemy]


//MachineGunner
let machineGunnerOreCost: CGFloat = 200
let machineGunnerHealth: CGFloat = 50
let machineGunnerEnergy: CGFloat = 120
let machineGunnerSightRadius: CGFloat = 140
let machineGunnerBaseSpeed: CGFloat = 60
let machineGunnerBaseRotateSpeed: CGFloat = 2
let machineGunnerTurretRotateSpeed: CGFloat = 2
let machineGunnerStates: [stateType] = [.Wander, .NeedRepair, .Repairing, .Attack, .NeedCharge, .Recharge, .MoveToKnownEnemy]

//ScatterShot
let scatterShotOreCost: CGFloat = 250
let scatterShotHealth: CGFloat = 50
let scatterShotEnergy: CGFloat = 120
let scatterShotSightRadius: CGFloat = 100
let scatterShotBaseSpeed: CGFloat = 50
let scatterShotBaseRotateSpeed: CGFloat = 2
let scatterShotTurretRotateSpeed: CGFloat = 2
let scatterShotStates: [stateType] = [.Wander, .NeedRepair, .Repairing, .Attack, .NeedCharge, .Recharge, .MoveToKnownEnemy]

let scatterShotBulletsPerShot: Int = 6

//Artillery
let artilleryOreCost: CGFloat = 1000
let artilleryHealth: CGFloat = 100
let artilleryEnergy: CGFloat = 200
let artillerySightRadius: CGFloat = 300
let artilleryBaseSpeed: CGFloat = 25
let artilleryBaseRotateSpeed: CGFloat = 0.5
let artilleryTurretRotateSpeed: CGFloat = 0.5
let artilleryStates: [stateType] = [.Wander, .NeedRepair, .Repairing, .Attack, .NeedCharge, .Recharge, .MoveToKnownEnemy]

let rocketRocketsPerReload: Int = 3

//STRUCTURES
let structureMaxGuardPostitions: Int = 4

//GuardTurrets
//Bullet Guard Turret
let bulletGuardTurretHealth: CGFloat = 100
let bulletGuardTurretSightRadius: CGFloat = 200
let bulletGuardTurretStates: [stateType] = [.Attack]

//Headquarters
let HQHealth: CGFloat = 400
let HQSightRadius: CGFloat = 300
let HQStates: [stateType] = [.BuildAutos]


//Repair Station
let RSSightRadius: CGFloat = 200

let RSHealth: CGFloat = 200
let RSRepairAmount: CGFloat = 4

//Charging Station
let CSSightRadius: CGFloat = 200

let CSChargeAmount: CGFloat = 10.0

//PROJECTILES

//Rocket
let rocketDamage: CGFloat = 10
let rocketReloadTime: Int = 500
let rocketRange: CGFloat = 500
let rocketMovementSpeed: CGFloat = 0.2

let rocketExplosionLifeTime: Int = 120
let rocketExplosionRadius: CGFloat = 20

//MediumBullet
let mediumBulletDamage: CGFloat = 5
let mediumBulletReloadTime: Int = 50
let mediumBulletRange: CGFloat = 300
let mediumBulletMovementSpeed: CGFloat = 0.5 //Movement speed it the amount of seconds it takes to move 100 units

//SmallBullet
let smallBulletDamage: CGFloat = 2
let smallBulletReloadTime: Int = 10
let smallBulletRange: CGFloat = 200
let smallBulletMovementSpeed: CGFloat = 0.5

//ORES
let oreScale: CGFloat = 0.5

let smallOreAmount:CGFloat = 300
let mediumOreAmount: CGFloat = 600
let largeOreAmount: CGFloat = 1000
let hugeOreAmount: CGFloat = 2000

let smallOreRadius:CGFloat = 25 * oreScale
let mediumOreRadius: CGFloat = 40 * oreScale
let largeOreRadius: CGFloat = 60 * oreScale
let hugeOreRadius: CGFloat = 100 * oreScale


