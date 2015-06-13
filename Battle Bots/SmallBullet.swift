//
//  SmallBullet.swift
//  Battle Bots
//
//  Created by Alec Shedelbower on 6/6/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import Foundation
import SpriteKit

class SmallBullet: Projectile {
    
    override var type: projectileType? {
        get{return .SmallBullet}
        set{self.type = .SmallBullet}
    }
    
    override var damage: CGFloat? {
        get{return smallBulletDamage}
        set{self.damage = smallBulletDamage}
    }
    
    override var range: CGFloat? {
        get{return smallBulletRange}
        set{self.damage = smallBulletRange}
    }
    
    
    init(turretNode: SKSpriteNode, mechanism: Mechanism , world: World) {
        
        let turretPositionInWorld = world.convertPoint(turretNode.position, fromNode: turretNode.parent!)
        
        super.init(fromPosition: turretPositionInWorld, mechanism: mechanism, world: world)
        
        self.turretNode = turretNode
        
        self.movementSpeed = smallBulletMovementSpeed
        
        self.bulletNode = SKSpriteNode(imageNamed: "SmallBullet")
        self.bulletNode!.setScale(autosScale)
        self.bulletNode!.zPosition = 9
        
        self.trailNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("bulletTrailSmall", ofType: "sks")!) as? SKEmitterNode
        
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