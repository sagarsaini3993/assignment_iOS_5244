//
//  GameScene.swift
//  assignment2_iOS_5244
//
//  Created by MacStudent on 2019-06-17.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var player:SKNode!
    var jumpButton:SKLabelNode!
    var level1 : SKNode!
    var level2 : SKNode!
    var level3 : SKNode!
    var level4 : SKNode!
    
    // GAME STAT SPRITES
    let livesLabel = SKLabelNode(text: "Lives: ")
    
    
    
    
    
    // GAME STATISTIC VARIABLES
    var lives = 2
    var movingEnemyRight :Bool = true
    
    
    override func didMove(to view: SKView) {
        
        // setup contact delegate
        self.physicsWorld.contactDelegate = self
        
        // set boundaries around the scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        //sprites
        self.level1 = self.childNode(withName: "level1")
        self.level2 = self.childNode(withName: "level2")
        self.level3 = self.childNode(withName: "level3")
        self.level4 = self.childNode(withName: "level4")
        // level1.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        self.jumpButton = self.childNode(withName: "jumpButton") as! SKLabelNode
        
        
        // MARK: Setup Player
        self.player = self.childNode(withName: "player") as! SKSpriteNode
        // make a physics body for the player
        self.player.physicsBody = SKPhysicsBody(rectangleOf: self.player!.frame.size)
        
        self.player.physicsBody?.isDynamic = false
        self.player.physicsBody?.affectedByGravity = false
        self.player.physicsBody?.allowsRotation = false
        
        // give him a category
        self.player.physicsBody?.categoryBitMask = 1        // set player cateogery = 1
        self.player.physicsBody?.contactTestBitMask = 2     //notify system when player hits cat
        
        
        
        
        var playerTextures:[SKTexture] = []
        for i in 1...4 {
            let fileName = "frame\(i)"
            print("Adding: \(fileName) to array")
            playerTextures.append(SKTexture(imageNamed: fileName))
        }
        
        let walkingAnimation = SKAction.animate(
            with: playerTextures,
            timePerFrame: 0.1)
        
        self.player.run(SKAction.repeatForever(walkingAnimation))
        
        
        // MARK: Add a lives label
        // ------------------------
        self.livesLabel.text = "Lives: \(self.lives)"
        self.livesLabel.fontName = "Avenir-Bold"
        self.livesLabel.fontColor = UIColor.magenta
        self.livesLabel.fontSize = 50;
        self.livesLabel.position = CGPoint(x:200,y:self.size.height-50)
        
        
        // MARK: Add your sprites to the screen
        addChild(livesLabel)
        
        self.makeEnemies()
        
    }
    
    
    //--------------------------------2 things contact ------------------------------
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        print("Collision detected!")
        print("Node A: \(nodeA!.name)  Node B: \(nodeB!.name)")
    }
    
    //--------------------------------move player-------------------------------
//    func moveShip (moveBy: CGFloat, forTheKey: String) {
//        let moveAction = SKAction.moveBy(x: moveBy, y: 0, duration: 1)
//        let repeatForEver = SKAction.repeatForever(moveAction)
//        let seq = SKAction.sequence([moveAction, repeatForEver])
//
//        //run the action on your ship
//        player.run(seq, withKey: forTheKey)
//    }
    
    //--------------------------------touch function-------------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        let touch = touches.first
        if (touch == nil) {
            return
        }
        
        let mouseLocation = touch!.location(in:self)
        let spriteTouched = self.atPoint(mouseLocation)
        
        
        if (spriteTouched.name == "jumpButton") {
            print("PRESSED THE BUTTON")
            
            let jumpAction = SKAction.applyImpulse(
                CGVector(dx:0, dy:2000),
                duration: 0.5)
            
            self.player.run(jumpAction)
            
        }
        
        if (spriteTouched.name == "up") {
            print("UP PRESSED")
            if(self.player.position.y <= self.frame.size.height-250)
            {
                self.player.position.y = self.player.position.y + 150
            }
            
            
        }
        else if (spriteTouched.name == "down") {
            print("DOWN PRESSED")
            if(self.player.position.y >= 150)
            {
                self.player.position.y = self.player.position.y - 150
            }
        }
        else if (spriteTouched.name == "left") {
            print("LEFT PRESSED")
            self.player.position.x = self.player.position.x - 50
        }
        else if (spriteTouched.name == "right") {
            print("RIGHT PRESSED")
            self.player.position.x = self.player.position.x + 50
        }
        
    }
    
    //---------------------Update function--------------------------------
    var timeOfLastUpdate:TimeInterval?
 
    override func update(_ currentTime: TimeInterval) {
        
        
        //self.player.position.x = self.player.position.x + 10
        
        if (self.player.position.x >= self.size.width) {
            self.player.position.x = 10
        }
        if (self.player.position.x < 0) {
            self.player.position.x = self.size.width-100
        }
        
        //move enemy
        
        
        for i in 0..<levelOneEnemies.count {
            // move enemy left and righ
            let enemy = levelOneEnemies[i]
            enemy.position.x = enemy.position.x + 10
            if (enemy.position.x > self.frame.width) {
                enemy.position.x = 0
            }
        }
        

        for i in 0..<level2Enemies.count {
            // move enemy left and righ
            let enemy = level2Enemies[i]
            enemy.position.x = enemy.position.x + 5
            if (enemy.position.x > self.frame.width) {
                enemy.position.x = 0
            }
        }
        
        
        
        
        
//        if(movingEnemyRight == true)
//        {
//            let RightMoveAction = SKAction.scaleX(to: +1, duration: 0)
//            self.enemy.run(RightMoveAction)
//            self.enemy1.run(RightMoveAction)
//            enemy.position.x =     enemy.position.x + 10;
//            enemy1.position.x =     enemy1.position.x + 10;
//            if(enemy.position.x >= self.frame.width || enemy1.position.x >= self.frame.width )
//            {
//                movingEnemyRight = false
//            }
//        }
//        else if (movingEnemyRight == false){
//
//            let leftMoveAction = SKAction.scaleX(to: -1, duration: 0)
//            self.enemy.run(leftMoveAction)
//            self.enemy1.run(leftMoveAction)
//            enemy.position.x =     enemy.position.x - 10;
//            enemy1.position.x =     enemy1.position.x - 10;
//            if(enemy.position.x <= 0 || enemy1.position.x <= 0  )
//            {
//                movingEnemyRight = true
//            }
//
//        }
        
        if (timeOfLastUpdate == nil) {
            timeOfLastUpdate = currentTime
        }
        // print a message every 3 seconds
        var timePassed = (currentTime - timeOfLastUpdate!)
        if (timePassed >= 1.5) {
            if(levelOneEnemies.count <= 5 )
            {
            print("HERE IS A MESSAGE!")
            timeOfLastUpdate = currentTime
            // make a cat
            self.makeEnemies()
            }
            if(level2Enemies.count <= 5 )
            {
                print("HERE IS A MESSAGE!")
                timeOfLastUpdate = currentTime
                // make a cat
                self.makeEnemies()
            }
        }

    }
   
    // MARK: MAKE ENEMIES
    var levelOneEnemies:[SKSpriteNode] = []
    var level2Enemies:[SKSpriteNode] = []
    func makeEnemies() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        let enemy1 = SKSpriteNode(imageNamed: "enemy")
        
        // lets add some enemies
        // generate a random (x,y) for the cat
        let randX = Int(level1.position.x )
        let randY = Int(level1.position.y + 70)
        enemy.position = CGPoint(x:randX, y:randY)
        print("enemy position \(randX) \(randY)")
        
        
        // setup physics for each cat
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        
        // give him a category
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.contactTestBitMask = 1
        
        
        addChild(enemy)
        
        // add enemy to level 1 array
        self.levelOneEnemies.append(enemy);
        
        
        //-------------------second enemy------
        let randX1 = Int(level2.position.x )
        let randY1 = Int(level2.position.y + 70)
        enemy1.position = CGPoint(x:randX1, y:randY1)
        print("enemy position \(randX) \(randY)")
        
        // setup physics for each cat
        enemy1.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy1.physicsBody?.isDynamic = false
        enemy1.physicsBody?.affectedByGravity = false
        enemy1.physicsBody?.allowsRotation = false
        
        // give him a category
        enemy1.physicsBody?.categoryBitMask = 2
        enemy1.physicsBody?.contactTestBitMask = 1
        
        addChild(enemy1)
        // add enemy to level 1 array
        self.level2Enemies.append(enemy1)
        
        
        
        
        
    }
    
}

