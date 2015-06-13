//
//  MediumBullet.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 6/4/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class MediumBullet: Projectile {
    
    override var type: projectileType? {
        get{return .MediumBullet}
        set{self.type = .MediumBullet}
    }
    
    override var damage: CGFloat? {
        get{return mediumBulletDamage}
        set{self.damage = mediumBulletDamage}
    }
    
    override var range: CGFloat? {
        get{return mediumBulletRange}
        set{self.damage = mediumBulletRange}
    }
    
    
    init(turretNode: SKSpriteNode, mechanism: Mechanism, world: World) {
        
        let turretPositionInWorld = world.convertPoint(turretNode.position, fromNode: turretNode.parent!)
        
        super.init(fromPosition: turretPositionInWorld, mechanism: mechanism, world: world)
        
        self.turretNode = turretNode
        
        self.movementSpeed = mediumBulletMovementSpeed
        
        self.bulletNode = SKSpriteNode(imageNamed: "MediumBullet")
        self.bulletNode!.setScale(autosScale)
        self.bulletNode!.zPosition = 3.5
        
        self.trailNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("bulletTrail", ofType: "sks")!) as? SKEmitterNode
        
        self.trailNode!.targetNode = world
        
        self.bodyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.bulletNode!.frame.width, height: self.bulletNode!.frame.height))
        self.bodyNode.physicsBody?.affectedByGravity = false
        self.bodyNode.physicsBody?.categoryBitMask = physicsCategory.Projectile.rawValue
        self.bodyNode.physicsBody?.collisionBitMask = physicsCategory.None.rawValue
        self.bodyNode.physicsBody?.contactTestBitMask = physicsCategory.Projectile.rawValue | physicsCategory.Auto.rawValue | physicsCategory.Structure.rawValue
        
        self.addChild(bodyNode)
        self.bodyNode.addChild(bulletNode!)
        world.addChild(trailNode!)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func explode() {
        let explosion = BulletExplosion(world: self.world, lifeTime: 120)
        self.world.addChild(explosion)
        explosion.position = self.position
        super.explode()
    }
    
}