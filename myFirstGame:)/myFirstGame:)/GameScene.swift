//
//  GameScene.swift
//  myFirstGame:)
//
//  Created by user152277 on 4/3/19.
//  Copyright © 2019 user152277. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ball : SKSpriteNode?
    var gameTime : Timer?
    var ground : SKSpriteNode?
    var ceiling : SKSpriteNode?
    var scoreLabel : SKLabelNode?
    
    
    let ballCategory : UInt32 = 0x1 << 1
    let coinCategory : UInt32 = 0x1 << 2
    let explCategory : UInt32 = 0x1 << 3
    let groundAndCeilingCategory : UInt32 = 0x1 << 4
    
    var score = 0
    
    override func didMove(to view: SKView) {
        
        
        
       
    //collision
    physicsWorld.contactDelegate = self
        
    ball = childNode(withName: "ball") as? SKSpriteNode
    ball?.physicsBody?.categoryBitMask = ballCategory
    ball?.physicsBody?.contactTestBitMask = coinCategory | explCategory
    
    ground = childNode(withName: "ground") as? SKSpriteNode
    ground?.physicsBody?.categoryBitMask = groundAndCeilingCategory
    ground?.physicsBody?.collisionBitMask = groundAndCeilingCategory
    
    ceiling = childNode(withName: "ground") as? SKSpriteNode
    ceiling?.physicsBody?.categoryBitMask = groundAndCeilingCategory
    ground?.physicsBody?.collisionBitMask = ballCategory
        
        
        scoreLabel = childNode(withName: "scoreLabel")as?
            SKLabelNode
        //setup tim
        gameTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.generateCoin()
        })
    }
        
    
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        ball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 20000))
        
        }
        
    func generateCoin() {
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = ballCategory
        coin.physicsBody?.collisionBitMask = 0
        addChild(coin)
    
    
        //setting the height structure
        let maximumY = size.height / 2 - coin.size.height / 2
        let minimumY = -size.height / 2 + coin.size.height / 2
        let range = maximumY - minimumY
        let coinY = maximumY - CGFloat(arc4random_uniform(UInt32(range)))
        
        //setup variables
        coin.position = CGPoint(x: size.width / 2 + coin.size.width / 2, y: coinY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - coin.size.width, y: 0, duration: 5)
        coin.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
        
        func didBegin(_ contact: SKPhysicsContact){
            score += 1
            scoreLabel?.text = "Score: \(score)"
    
    //Business rules
    if contact.bodyA.categoryBitMask == coinCategory {
        contact.bodyA.node?.removeFromParent()
    }
    if contact.bodyB.categoryBitMask == coinCategory {
        contact.bodyB.node?.removeFromParent()
    }
        
        }
}
