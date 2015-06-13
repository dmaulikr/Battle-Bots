//
//  Projectile.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/3/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

var projectileNameCount: Int = 0
let projectileName: String = "projectile"

class Projectile: SKNode {
    var type: projectileType?
    var mechanism: Mechanism?
    var team: Team?
    var movementSpeed: CGFloat?
    var damage: CGFloat?
    var range: CGFloat?
    
    var world: World
    
    var bodyNode =  SKNode()
    var turretNode: SKSpriteNode?
    var bulletNode: SKSpriteNode?
    var trailNode: SKEmitterNode?
    
    init(fromPosition: CGPoint, mechanism: Mechanism, world: World) {
        self.world = world
        self.mechanism = mechanism
        self.team = mechanism.team
    
        super.init()
        
        projectileNameCount += 1
        self.name = "\(projectileName)\(projectileNameCount)"
        
        self.position = fromPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire() {
        
        let rotationAngle: CGFloat = self.turretNode!.zRotation + self.turretNode!.parent!.zRotation + CGFloat(M_PI_2)
        self.zRotation = rotationAngle - CGFloat(M_PI_2)
        //self.position = self.turretNode!.position
        
        let distX: CGFloat = CGFloat(cosf(Float(rotationAngle))) * self.range!
        let distY: CGFloat = CGFloat(sinf(Float(rotationAngle))) * self.range!
        
        let randX = CGFloat(getRandomInt(-20, 20))/100 * self.range!
        let randY = CGFloat(getRandomInt(-20, 20))/100 * self.range!
        
        let trajectory: CGVector = CGVector(dx: distX + randX, dy: distY + randY)
//        let newRotationAngle: CGFloat = CGFloat(tanf(Float(trajectory.dy/trajectory.dx))) + CGFloat(M_PI_2)
//        self.zRotation = newRotationAngle
        
        let duration: NSTimeInterval = NSTimeInterval(self.movementSpeed! * (self.range!/100))

        
        let actionFireBullet = SKAction.moveBy(trajectory, duration: duration)
        
        let actionRemoveBulletAndTrail = SKAction.sequence([SKAction.runBlock({self.trailNode!.particleBirthRate = 0; self.bodyNode.removeFromParent()}), SKAction.waitForDuration(NSTimeInterval(self.trailNode!.particleLifetime)),SKAction.runBlock({self.trailNode!.removeFromParent()}), SKAction.removeFromParent()])
        
        let actionFireAndRemove = SKAction.sequence([actionFireBullet, actionRemoveBulletAndTrail])
        
        //rotateNodeTowardsPoint(self, destination, 0.01)
        
        self.runAction(actionFireAndRemove, withKey: keyBulletFiring)
    }
    
    func madeContactWith(mechanism: Mechanism) {
        if mechanism.team.name != self.team!.name {
            mechanism.takeDamage(self.damage!)
            mechanism.team.addEnemyMechanism(self.mechanism!)
            self.explode()
        }
    }
    
    func update() {
        if self.trailNode != nil && self.bulletNode != nil{
            self.trailNode?.position = self.position
        }
    }
    
    func removeBulletAndTrail() {
        let actionRemoveBulletNode = SKAction.runBlock({self.bodyNode.removeFromParent()})
        let actionSetBirthRateToZero = SKAction.runBlock({self.trailNode!.particleBirthRate = 0})
        let particleLifeTime: NSTimeInterval = NSTimeInterval(self.trailNode!.particleLifetime)
        let actionWaitForDuration = SKAction.waitForDuration(particleLifeTime)
        let actionRemoveTrailNode = SKAction.runBlock({self.trailNode!.removeFromParent()})
        
        let actionRemoveBulletAndLeaveTrail = SKAction.sequence([actionRemoveBulletNode, actionSetBirthRateToZero, actionWaitForDuration, actionRemoveTrailNode, SKAction.removeFromParent()])
        
        self.runAction(actionRemoveBulletAndLeaveTrail)
    }
    
    func explode() {
        removeBulletAndTrail()
    }
    
}