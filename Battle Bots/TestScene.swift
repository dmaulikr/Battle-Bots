//
//  TestScene.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/11/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene: GameScene {
    
    var scout: Scout?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        world!.changeBoundaryTo("Boundary_2")
        
        let team1 = Team(name: "Player")
        let team2 = Team(name: "Enemy")
        
//        let ore = OreDeposit(size: .Huge, world: world!)
//        world?.addChild(ore)
//        ore.position = CGPoint(x: -200, y: 800)
        
        let ore2 = OreDeposit(size: .Huge  , world: world!)
        world?.addChild(ore2)
        ore2.position = CGPoint(x: -200, y: -800)
        
//        let ore3 = OreDeposit(size: .Huge, world: world!)
//        world?.addChild(ore3)
//        ore3.position = CGPoint(x: 200, y: 800)
        
        let ore4 = OreDeposit(size: .Huge  , world: world!)
        world?.addChild(ore4)
        ore4.position = CGPoint(x: 200, y: -800)
        
        
        let HQ = Headquarters(team: team1, world: world!)
        HQ.doAdditionalSetUp()
        world?.addChild(HQ)
        HQ.position = CGPoint(x: 0, y: 650)
        
        let HQ2 = Headquarters(team: team2, world: world!)
        HQ2.doAdditionalSetUp()
        world?.addChild(HQ2)
        HQ2.position = CGPoint(x: 0, y: -650)
        
        let miner = Miner(team: team1, world: world!)
        miner.doAdditionalSetUp()
        world!.addChild(miner)
        miner.position = CGPoint(x: 0, y: 200)
        
        let miner2 = Miner(team: team2, world: world!)
        miner2.doAdditionalSetUp()
        world!.addChild(miner2)
        miner2.position = CGPoint(x: 200, y: -700)
        
        let miner3 = Miner(team: team2, world: world!)
        miner3.doAdditionalSetUp()
        world!.addChild(miner3)
        miner3.position = CGPoint(x: 50, y: 200)
        
        let CS = ChargingStation(team: team1, world: world!)
        CS.doAdditionalSetUp()
        CS.position = CGPoint(x: 150, y: 500)
        world?.addChild(CS)
        
        let CS2 = ChargingStation(team: team2, world: world!)
        CS2.doAdditionalSetUp()
        CS2.position = CGPoint(x: -150, y: -500)
        world?.addChild(CS2)
        
        let RS = RepairStation(team: team1, world: world!)
        RS.doAdditionalSetUp()
        RS.position = CGPoint(x: -150, y: 500)
        world?.addChild(RS)
        
        let RS2 = RepairStation(team: team2, world: world!)
        RS2.doAdditionalSetUp()
        RS2.position = CGPoint(x: 150, y: -500)
        world?.addChild(RS2)
        
        let BGT = BulletGuardTurret(team: team1, world: world!)
        BGT.doAdditionalSetUp()
        BGT.position = CGPoint(x: 0, y: 400)
        world?.addChild(BGT)
        
//        let BGT2 = BulletGuardTurret(team: team2, world: world!)
//        BGT2.doAdditionalSetUp()
//        BGT2.position = CGPoint(x: 0, y: -400)
//        world?.addChild(BGT2)
        
//        scout = Scout(team: team1, world: world!)
//        scout?.doAdditionalSetUp()
//        scout!.position = CGPoint(x: 0, y: -100)
//        
//        let scout2 = Scout(team: team2, world: world!)
//        scout2.doAdditionalSetUp()
//        scout2.position = CGPoint(x: 0, y: 100)
        
//        let lightArmor = LightArmor(team: team2, world: world!)
//        lightArmor.doAdditionalSetUp()
//        lightArmor.position = CGPoint(x: -100, y: 200)
//        
//        let lightArmor2 = LightArmor(team: team2, world: world!)
//        lightArmor2.doAdditionalSetUp()
//        lightArmor2.position = CGPoint(x: 100, y: 200)
//        
//        let lightArmor3 = LightArmor(team: team1, world: world!)
//        lightArmor3.doAdditionalSetUp()
//        lightArmor3.position = CGPoint(x: -50, y: -200)
//        
//        
//        let lightArmor4 = LightArmor(team: team1, world: world!)
//        lightArmor4.doAdditionalSetUp()
//        lightArmor4.position = CGPoint(x: 50, y: -200)
        
//        let machineGunner = MachineGunner(team: team1, world: world!)
//        machineGunner.doAdditionalSetUp()
//        machineGunner.position = CGPoint(x: 0, y: -50)
//        
//        let machineGunner2 = MachineGunner(team: team2, world: world!)
//        machineGunner2.doAdditionalSetUp()
//        machineGunner2.position = CGPoint(x: 0, y: 200)
        
//        let machineGunner3 = MachineGunner(team: team1, world: world!)
//        machineGunner3.doAdditionalSetUp()
//        machineGunner3.position = CGPoint(x: 0, y: -300)
//        
//        let machineGunner4 = MachineGunner(team: team2, world: world!)
//        machineGunner4.doAdditionalSetUp()
//        machineGunner4.position = CGPoint(x: 0, y: 300)
//        
//        let medic = Medic(team: team1, world: world!)
//        medic.doAdditionalSetUp()
//        medic.position = CGPoint(x: 0, y: -325)
//        
//        let medic2 = Medic(team: team2, world: world!)
//        medic2.doAdditionalSetUp()
//        medic2.position = CGPoint(x: 0, y: 325)
        
        //        let medic3 = Medic(team: team1, world: world!)
        //        medic3.doAdditionalSetUp()
        //        medic3.position = CGPoint(x: 100, y: -325)
        //
        //        let medic4 = Medic(team: team2, world: world!)
        //        medic4.doAdditionalSetUp()
        //        medic4.position = CGPoint(x: -100, y: 325)
        
//        let scatterShot = ScatterShot(team: team1, world: world!)
//        scatterShot.doAdditionalSetUp()
//        scatterShot.position = CGPoint(x: 0, y: -400)
//        
//        let scatterShot2 = ScatterShot(team: team2, world: world!)
//        scatterShot2.doAdditionalSetUp()
//        scatterShot2.position = CGPoint(x: 0, y: 400)
//        
//        let artillery = Artillery(team: team1, world: world!)
//        artillery.doAdditionalSetUp()
//        artillery.position = CGPoint(x: 0, y: -300)
//        
//        let artillery2 = Artillery(team: team2, world: world!)
//        artillery2.doAdditionalSetUp()
//        artillery2.position = CGPoint(x: 0, y: 200)
        
//        world?.addChild(artillery)
//        world?.addChild(artillery2)
//
//        world?.addChild(scatterShot)
//        world?.addChild(scatterShot2)
//        
//        world!.addChild(scout2)
//        world!.addChild(scout!)
        
//        world?.addChild(medic)
//        world?.addChild(medic2)
        //        world?.addChild(medic3)
        //        world?.addChild(medic4)
        //
//        world?.addChild(lightArmor)
//        world?.addChild(lightArmor2)
//        world?.addChild(lightArmor3)
//        world?.addChild(lightArmor4)
        
//        world?.addChild(machineGunner)
//        world?.addChild(machineGunner2)
//        world?.addChild(machineGunner3)
//        world?.addChild(machineGunner4)
        
        self.makeSightNodesHidden(true)
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for touch in (touches as! Set<UITouch>) {
//            touchController?.addTouch(touch)
//        }
//    }
//    
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for touch in (touches as! Set<UITouch>) {
//            touchController?.touchMoved(touch)
//        }
//    }
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for touch in (touches as! Set<UITouch>) {
//            touchController?.removeTouch(touch)
//        }
//    }
    
    
    
}