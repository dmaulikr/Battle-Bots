//
//  GameScene.swift
//  Bot Warefare
//
//  Created by Alec Shedelbower on 5/28/15.
//  Copyright (c) 2015 Alec Shedelbower. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Touches
    var initialTouchLocation: CGPoint?
    var endTouchLocation: CGPoint?
    var currentTouchLocation: CGPoint?
    var currentTouches = [UITouch]()
    
    var shouldFollowMechanism: Bool = false
    var mechanismToFollowName: String?

    // The root node of your game world. Attach game entities
    // (player, enemies, &c.) to here.
    var world: World?
    // The root node of our UI. Attach control buttons & state
    // indicators here.
    var overlay: SKNode?
    // The camera. Move this node to change what parts of the world are visible.
    var camera: SKNode?
    let worldName = "world"
    let cameraName = "camera"
    let overlayName = "overlay"
    
    var doorTransition: DoorTransition?
    
    var gameShouldStart: Bool = true
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        self.view?.showsPhysics = false
        
        
        self.backgroundColor = SKColor.blackColor() //SKColor(red: 210/255, green: 200/255, blue: 130/255, alpha: 1.0)
        
        // Camera setup
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.world = World()
        self.world?.name = worldName
        self.addChild(self.world!)
        self.camera = SKNode()
        self.camera?.name = cameraName
        self.world?.addChild(self.camera!)
        
        // UI setup
        self.overlay = SKNode()
        self.overlay?.zPosition = 10
        self.overlay?.name = overlayName
        addChild(self.overlay!)
        
        //Transition setup
        self.doorTransition = DoorTransition(type: .Horizontal, scene: self, initialState: .Open)
        self.addChild(self.doorTransition!)
        
    }
    
    func doDoorTransition(duration: NSTimeInterval) {
        let doorTransitionDuration: NSTimeInterval = duration / 2
        let actionTransitionSequence = SKAction.sequence([SKAction.runBlock({self.doorTransition?.closeDoors(doorTransitionDuration)}), SKAction.waitForDuration(doorTransitionDuration), SKAction.runBlock({self.transitionToLevelSelectScene()})])
        self.runAction(actionTransitionSequence)
    }
    
    func makeSightNodesHidden(hidden: Bool) {
        world?.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            if let auto = node as? Auto {
                auto.sightNode!.hidden = hidden
            }
            if let structure = node as? Structure {
                structure.sightNode!.hidden = hidden
            }

        }
    }
    
    func centerOnNode(node: SKNode, immediately: Bool) {
        let cameraPositionInScene: CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!)
        
        let newLocation = CGPoint(x:node.parent!.position.x - cameraPositionInScene.x, y:node.parent!.position.y - cameraPositionInScene.y)
        if immediately {
            node.parent!.position = newLocation
        }
        else {
            node.parent!.runAction(SKAction.moveTo(newLocation, duration: 0.5))
        }
    }
    
    func findNearestMechanism(point: CGPoint) -> Mechanism {
        var mechanisms: [Mechanism] = []
        var mechanismDistances: [CGFloat] = []
        
        world?.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            let mechanism = node as! Mechanism
            mechanisms.append(mechanism)
            mechanismDistances.append(getDistance(point, mechanism.position))
        }
        return mechanisms[find(mechanismDistances,minElement(mechanismDistances))!]
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
//        world?.enumerateChildNodesWithName("\(mechanismName)*") {
//            node, stop in
//            if let miner = node as? Miner {
//                let ore = self.world?.childNodeWithName("ore1") as! OreDeposit
//                miner.mine(ore)
//            }
//        }
        
        for touch in (touches as! Set<UITouch>) {
            currentTouches.append(touch)
            if currentTouches.count >= 3 {
                doDoorTransition(1)
            }
            
            var location = touch.locationInNode(world)
            initialTouchLocation = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            var location = touch.locationInNode(world)
            endTouchLocation = touch.locationInNode(self)
            
            if contains(currentTouches, touch) {
                currentTouches.removeAtIndex(find(currentTouches,touch)!)
            }
        
            let distance = getDistance(initialTouchLocation!, endTouchLocation!)
            if distance > 30 {
                if world?.xScale < 50 && world?.xScale > 0.1 {
                    if distance >= 10 {
                        let distX = endTouchLocation!.x - initialTouchLocation!.x
                        let distY = endTouchLocation!.y - initialTouchLocation!.y
                        if abs(distY) > 10 {
                            var newScale = world!.xScale - distY/100
                            if newScale < 0.5 {
                                newScale = 0.5
                            }
                            else if newScale > 3 {
                                newScale = 3
                            }
                            world?.runAction(SKAction.scaleTo(newScale, duration: 0.2), withKey: "scaling")
                        }
                    }
                }
            }
            else {
                let nearestMechanism = findNearestMechanism(location)
                if getDistance(nearestMechanism.position, location) <= 50 {
                    shouldFollowMechanism = true
                    mechanismToFollowName = nearestMechanism.name!
                }
                else{
                    shouldFollowMechanism = false
                    camera?.position = location
                    centerOnNode(camera!, immediately: false)
                }
            }
        }
    }

   
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if gameShouldStart {
            updateMechanisms()
            updateExplosions()
            updateProjectiles()
        }
        
        if world?.actionForKey("scaling") != nil {
            if shouldFollowMechanism {
                if let mechanism = world?.childNodeWithName(mechanismToFollowName!) as? Mechanism {
                    centerOnNode(mechanism, immediately: true)
                }
            }
            else {
                centerOnNode(camera!, immediately: true)
            }
        }
        else {
            if shouldFollowMechanism {
                if let mechanism = world?.childNodeWithName(mechanismToFollowName!) as? Mechanism {
                    centerOnNode(mechanism, immediately: false)
                }
            }
        }
        
    }
    
    func updateMechanisms() {
        world?.enumerateChildNodesWithName("\(mechanismName)*") {
            node, stop in
            if let mechanism = node as? Mechanism {
                mechanism.update()
            }
        }
    }
    
    func updateExplosions() {
        world?.enumerateChildNodesWithName("\(explosionName)*") {
            node, stop in
            if let explosion = node as? Explosion {
                explosion.update()
            }
        }
    }
    
    func updateProjectiles() {
        world?.enumerateChildNodesWithName("\(projectileName)*") {
            node, stop in
            if let projectile = node as? Projectile {
                projectile.update()
            }
        }
    }
    
    func otherContact() {
        //Do Nothing
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case physicsCategory.Auto.rawValue | physicsCategory.Auto.rawValue:
            //When two autos collide
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var auto1 = contact.bodyA.node?.parent as! Auto
                var auto2 = contact.bodyB.node?.parent as! Auto
                
                auto1.didCollideWithMechanism(auto2)
                auto2.didCollideWithMechanism(auto1)
            }
        
        case physicsCategory.Structure.rawValue | physicsCategory.Auto.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var auto: Auto
                var structure: Structure
                if contact.bodyA.categoryBitMask == physicsCategory.Auto.rawValue {
                    auto = contact.bodyA.node?.parent as! Auto
                    structure = contact.bodyB.node as! Structure
                } else {
                    auto = contact.bodyB.node?.parent as! Auto
                    structure = contact.bodyA.node as! Structure
                }
                
                auto.didCollideWithMechanism(structure)
                structure.didCollideWithMechanism(auto)
            }
            
            
        case physicsCategory.Structure.rawValue | physicsCategory.Sight.rawValue:
            //When a structure is spotted by a mechanism
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var structure: Structure
                var mechanism: Mechanism
                if contact.bodyA.categoryBitMask == physicsCategory.Structure.rawValue {
                    structure = contact.bodyA.node as! Structure
                    mechanism = contact.bodyB.node?.parent as! Mechanism
                } else {
                    mechanism = contact.bodyA.node?.parent as! Mechanism
                    structure = contact.bodyB.node as! Structure
                }
                
                mechanism.didSpotMechanism(structure)
            }
            
        case physicsCategory.Auto.rawValue | physicsCategory.Sight.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var auto: Auto
                var mechanism: Mechanism
                if contact.bodyA.categoryBitMask == physicsCategory.Auto.rawValue {
                    auto = contact.bodyA.node?.parent as! Auto
                    mechanism = contact.bodyB.node?.parent as! Mechanism
                } else {
                    auto = contact.bodyB.node?.parent as! Auto
                    mechanism = contact.bodyA.node?.parent as! Mechanism
                }
                
                mechanism.didSpotMechanism(auto)
            }
            
        case physicsCategory.Projectile.rawValue | physicsCategory.Auto.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var projectile: Projectile
                var auto: Auto
                if contact.bodyA.categoryBitMask == physicsCategory.Projectile.rawValue{
                    projectile = contact.bodyA.node?.parent as! Projectile
                    auto = contact.bodyB.node?.parent as! Auto
                } else {
                    projectile = contact.bodyB.node?.parent as! Projectile
                    auto = contact.bodyA.node?.parent as! Auto
                }
                
                projectile.madeContactWith(auto)
            }
            
        
        case physicsCategory.Projectile.rawValue | physicsCategory.Structure.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var projectile: Projectile
                var structure: Structure
                if contact.bodyA.categoryBitMask == physicsCategory.Projectile.rawValue{
                    projectile = contact.bodyA.node?.parent as! Projectile
                    structure = contact.bodyB.node as! Structure
                } else {
                    projectile = contact.bodyB.node?.parent as! Projectile
                    structure = contact.bodyA.node as! Structure
                }
                
                projectile.madeContactWith(structure)
            }
            
        case physicsCategory.Projectile.rawValue | physicsCategory.Projectile.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                let projectile1 = contact.bodyA.node?.parent as! Projectile
                let projectile2 = contact.bodyB.node?.parent as! Projectile
                
                if projectile1.team?.name != projectile2.team?.name {
                    projectile1.explode()
                    projectile2.explode()
                }
            }
        case physicsCategory.Explosion.rawValue | physicsCategory.Auto.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var explosion: DamageExplosion
                var auto: Auto
                if contact.bodyA.categoryBitMask == physicsCategory.Explosion.rawValue{
                    explosion = contact.bodyA.node?.parent as! DamageExplosion
                    auto = contact.bodyB.node?.parent as! Auto
                } else {
                    explosion = contact.bodyB.node?.parent as! DamageExplosion
                    auto = contact.bodyA.node?.parent as! Auto
                }
                
                explosion.madeContactWith(auto)
                
            }
        case physicsCategory.Explosion.rawValue | physicsCategory.Structure.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var explosion: DamageExplosion
                var structure: Structure
                if contact.bodyA.categoryBitMask == physicsCategory.Explosion.rawValue{
                    explosion = contact.bodyA.node?.parent as! DamageExplosion
                    structure = contact.bodyB.node as! Structure
                } else {
                    explosion = contact.bodyB.node?.parent as! DamageExplosion
                    structure = contact.bodyA.node as! Structure
                }
                
                explosion.madeContactWith(structure)
                
            }
        case physicsCategory.Ore.rawValue | physicsCategory.Sight.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var oreDeposit: OreDeposit
                var mechanism: Mechanism
                if contact.bodyA.categoryBitMask == physicsCategory.Ore.rawValue {
                    oreDeposit = contact.bodyA.node?.parent as! OreDeposit
                    mechanism = contact.bodyB.node?.parent as! Mechanism
                } else {
                    oreDeposit = contact.bodyB.node?.parent as! OreDeposit
                    mechanism = contact.bodyA.node?.parent as! Mechanism
                }
                
                mechanism.team.addOreDeposit(oreDeposit)
            }
        case physicsCategory.Ore.rawValue | physicsCategory.Auto.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var oreDeposit: OreDeposit
                var mechanism: Mechanism
                if contact.bodyA.categoryBitMask == physicsCategory.Ore.rawValue {
                    oreDeposit = contact.bodyA.node?.parent as! OreDeposit
                    mechanism = contact.bodyB.node?.parent as! Mechanism
                } else {
                    oreDeposit = contact.bodyB.node?.parent as! OreDeposit
                    mechanism = contact.bodyA.node?.parent as! Mechanism
                }
                
                if let miner = mechanism as? Miner {
                    miner.didCollideWithOreDeposit(oreDeposit)
                }
            }
        default:
            otherContact()
            // Nobody expects this, so satisfy the compiler and catch
            // ourselves if we do something we didn't plan to
            //fatalError("other collision: \(contactMask)")
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case physicsCategory.Auto.rawValue | physicsCategory.Auto.rawValue:
            //When two autos collide
            var auto1 = contact.bodyA.node?.parent as! Auto
            var auto2 = contact.bodyB.node?.parent as! Auto
            
            auto1.didEndCollisionWithMechanism(auto2)
            auto2.didEndCollisionWithMechanism(auto1)
            
        case physicsCategory.Structure.rawValue | physicsCategory.Auto.rawValue:
            var auto: Auto
            var structure: Structure
            if contact.bodyA.categoryBitMask == physicsCategory.Auto.rawValue {
                auto = contact.bodyA.node?.parent as! Auto
                structure = contact.bodyB.node as! Structure
            } else {
                auto = contact.bodyB.node?.parent as! Auto
                structure = contact.bodyA.node as! Structure
            }
            
            auto.didEndCollisionWithMechanism(structure)
            structure.didEndCollisionWithMechanism(auto)
            
            
        case physicsCategory.Structure.rawValue | physicsCategory.Sight.rawValue:
            //When a structure is spotted by a mechanism
            var structure: Structure
            var mechanism: Mechanism
            if contact.bodyA.categoryBitMask == physicsCategory.Structure.rawValue {
                structure = contact.bodyA.node as! Structure
                mechanism = contact.bodyB.node?.parent as! Mechanism
            } else {
                mechanism = contact.bodyA.node?.parent as! Mechanism
                structure = contact.bodyB.node as! Structure
            }
            
            mechanism.didLoseSightOfMechanism(structure)
            
        case physicsCategory.Auto.rawValue | physicsCategory.Sight.rawValue:
            var auto: Auto
            var mechanism: Mechanism
            if contact.bodyA.categoryBitMask == physicsCategory.Auto.rawValue {
                auto = contact.bodyA.node?.parent as! Auto
                mechanism = contact.bodyB.node?.parent as! Mechanism
            } else {
                auto = contact.bodyB.node?.parent as! Auto
                mechanism = contact.bodyA.node?.parent as! Mechanism
            }
            
            mechanism.didLoseSightOfMechanism(auto)
            
        case physicsCategory.Projectile.rawValue | physicsCategory.Auto.rawValue:
            var projectile: Projectile
            var auto: Auto
            if contact.bodyA.categoryBitMask == physicsCategory.Projectile.rawValue{
                projectile = contact.bodyA.node?.parent as! Projectile
                auto = contact.bodyB.node?.parent as! Auto
            } else {
                projectile = contact.bodyB.node?.parent as! Projectile
                auto = contact.bodyA.node?.parent as! Auto
            }
            
            
        case physicsCategory.Projectile.rawValue | physicsCategory.Structure.rawValue:
            var projectile: Projectile
            var structure: Structure
            if contact.bodyA.categoryBitMask == physicsCategory.Projectile.rawValue{
                projectile = contact.bodyA.node?.parent as! Projectile
                structure = contact.bodyB.node as! Structure
            } else {
                projectile = contact.bodyB.node?.parent as! Projectile
                structure = contact.bodyA.node as! Structure
            }
        case physicsCategory.Projectile.rawValue | physicsCategory.Projectile.rawValue:
            let projectile1 = contact.bodyA.node?.parent as! Projectile
            let projectile2 = contact.bodyB.node?.parent as! Projectile
            
        case physicsCategory.Ore.rawValue | physicsCategory.Auto.rawValue:
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                var oreDeposit: OreDeposit
                var mechanism: Mechanism
                if contact.bodyA.categoryBitMask == physicsCategory.Ore.rawValue {
                    oreDeposit = contact.bodyA.node?.parent as! OreDeposit
                    mechanism = contact.bodyB.node?.parent as! Mechanism
                } else {
                    oreDeposit = contact.bodyB.node?.parent as! OreDeposit
                    mechanism = contact.bodyA.node?.parent as! Mechanism
                }
                
                if let miner = mechanism as? Miner {
                    miner.didEndCollisionWithOreDeposit(oreDeposit)
                }
            }
        default:
            otherContact()
            // Nobody expects this, so satisfy the compiler and catch
            // ourselves if we do something we didn't plan to
            //fatalError("other collision: \(contactMask)")
        }
    }
    
    
    func transitionToLevelSelectScene() {
        println("Transitioning Scene")
        if let scene = LevelSelectScene.unarchiveFromFile("LevelSelectScene") as? LevelSelectScene {
            // Configure the view.
            let skView = self.view as SKView?
            skView?.showsFPS = false
            skView?.showsNodeCount = false
            skView?.showsPhysics = false
            
            println("Scene unarchived")
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView?.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.size = skView!.bounds.size
            
            //let transition = SKTransition.crossFadeWithDuration(1)
            
            let transition = SKTransition.doorsOpenHorizontalWithDuration(0.5)
            
            skView?.presentScene(scene, transition: transition)
        }
    }
    
}
