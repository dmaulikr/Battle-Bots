//
//  Rocket.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/9/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class Rocket: Projectile {
    
    override var type: projectileType? {
        get{return .Rocket}
        set{self.type = .Rocket}
    }
    
    override var damage: CGFloat? {
        get{return rocketDamage}
        set{self.damage = rocketDamage}
    }
    
    override var range: CGFloat? {
        get{return rocketRange}
        set{self.damage = rocketRange}
    }
    
    var targetLocation: CGPoint
    
    init(turretNode: SKSpriteNode, mechanism: Mechanism, world: World, targetLocation: CGPoint) {
        
        self.targetLocation = targetLocation
        let turretPositionInWorld = world.convertPoint(turretNode.position, fromNode: turretNode.parent!)
        
        super.init(fromPosition: turretPositionInWorld, mechanism: mechanism, world: world)
        
        self.turretNode = turretNode
        
        self.movementSpeed = rocketMovementSpeed
        
        self.bulletNode = SKSpriteNode(imageNamed: "Rocket")
        self.bulletNode!.setScale(autosScale)
        self.bulletNode!.zPosition = 3.5
        
        self.trailNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("rocketTrail", ofType: "sks")!) as? SKEmitterNode
        
        self.trailNode!.targetNode = world
        
        self.addChild(bodyNode)
        self.bodyNode.addChild(bulletNode!)
        world.addChild(trailNode!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomizePosition(point: CGPoint, randAmount: Int) -> CGPoint{
        let randX: CGFloat = CGFloat(getRandomInt(-randAmount, randAmount))
        let randY: CGFloat = CGFloat(getRandomInt(-randAmount, randAmount))
        
        let newPoint = CGPoint(x: point.x + randX, y: point.y + randY)
        return newPoint
    }
    
    override func fire() {
        let rotationAngle: CGFloat = self.turretNode!.zRotation + self.turretNode!.parent!.zRotation + CGFloat(M_PI_2)
        self.zRotation = rotationAngle - CGFloat(M_PI_2)
        
        let destination = self.randomizePosition(self.targetLocation, randAmount: 15)
        
        let duration: NSTimeInterval = NSTimeInterval(self.movementSpeed! * (self.range!/100))
        
        
        let actionFireRocket = SKAction.moveTo(destination, duration: duration)
        
        let actionRemoveRocketAndTrail = SKAction.sequence([SKAction.runBlock({self.trailNode!.particleBirthRate = 0; self.bodyNode.removeFromParent()}), SKAction.waitForDuration(NSTimeInterval(self.trailNode!.particleLifetime)),SKAction.runBlock({self.trailNode!.removeFromParent()}), SKAction.removeFromParent()])
        
        let actionFireRemoveExplode = SKAction.sequence([actionFireRocket, SKAction.runBlock({self.explode()}), actionRemoveRocketAndTrail])
        
        //rotateNodeTowardsPoint(self, destination, 0.01)
        
        self.runAction(actionFireRemoveExplode, withKey: keyBulletFiring)

    }
    
    override func explode() {
        let explosion = RocketExplosion(world: world, lifeTime: rocketExplosionLifeTime, mechanism: self.mechanism!, damage: self.damage!, maxRadius: rocketExplosionRadius)
        self.world.addChild(explosion)
        explosion.position = self.position
        super.explode()
    }
    
}