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
    let ScoreLabel = SKLabelNode(text: "Score: ")
    var playerDirection:String = ""
    
    
    
    
    // GAME STATISTIC VARIABLES
    var lives = 10
    var Score = 0
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
        
        self.player.physicsBody?.isDynamic = true
        self.player.physicsBody?.affectedByGravity = false
        self.player.physicsBody?.allowsRotation = false
        
        // give him a category
        self.player.physicsBody?.categoryBitMask = 1        // set player cateogery = 1
        self.player.physicsBody?.contactTestBitMask = 2
        //notify system when player hits cat
         self.player.physicsBody?.collisionBitMask = 0
        
        
        
        
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
        // MARK: Add a lives label
        // ------------------------
        self.ScoreLabel.text = "Score: \(self.Score)"
        self.ScoreLabel.fontName = "Avenir-Bold"
        self.ScoreLabel.fontColor = UIColor.magenta
        self.ScoreLabel.fontSize = 50;
        self.ScoreLabel.position = CGPoint(x:500,y:self.size.height-50)
        
        
        // MARK: Add your sprites to the screen
        addChild(ScoreLabel)
        addChild(livesLabel)
        self.makeEnemies()
        
    }
    
    
    //--------------------------------2 things contact ------------------------------
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
       // print("Collision detected!")
       // print("Node A: \(nodeA?.name)  Node B: \(nodeB?.name)")
        if(nodeA?.name == "player" && nodeB?.name == "cat")
        {
            print("player direction \(playerDirection)")
            if(playerDirection == "up" || playerDirection == "left" || playerDirection == "right" || playerDirection == "not moving")
            {
                print("playerDirection \(playerDirection)")
                self.lives = self.lives - 1
                print("lives after collision  \(self.lives)" )
                if(self.lives <= 0)
                {
                    print("game lose -----------")
                                        //go to lose game screen
                                        let scene = SKScene(fileNamed:"LoseGame")
                                        if (scene == nil) {
                                            print("Error loading level")
                                            return
                                        }
                                        else {
                                            scene!.scaleMode = .aspectFill
                                            view?.presentScene(scene!)
                                        }
                } else {
                    print("m in else")
                }
            }
            else if(playerDirection == "down"){
//                print("Player y position: \(nodeA?.position.y)")
//                print("Cat y position: \(nodeB?.position.y)")
                nodeB?.removeFromParent()
                self.Score = self.Score + 1
                if(levelOneEnemies.count == 0)
                {
                    print("level one enemies died")
                }
                if(level2Enemies.count == 0)
                {
                    print("level two enemies died")
                }
                
                
            }
            
        }
        
        //second condition
        if(nodeA?.name == "cat" && nodeB?.name == "player")
        {
            //print("player direction \(playerDirection)")
            if(playerDirection == "up" || playerDirection == "left" || playerDirection == "right" || playerDirection == "not moving")
            {
                print("playerDirection \(playerDirection)")
                self.lives = self.lives - 1
                print("lives after collision  \(self.lives)" )
                //lose Game
                
                if(self.lives <= 9)
                {
                    print("game lose -----------")
//                    //go to lose game screen
//                    let scene = SKScene(fileNamed:"LoseGame")
//                    if (scene == nil) {
//                        print("Error loading level")
//                        return
//                    }
//                    else {
//                        scene!.scaleMode = .aspectFill
//                        view?.presentScene(scene!)
//                    }
                } else {
                    print("m in else")
                }
            }
            else if(playerDirection == "down"){
                //                print("Player y position: \(nodeA?.position.y)")
                //                print("Cat y position: \(nodeB?.position.y)")
                nodeB?.removeFromParent()
            }
            
        }
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
            print(playerDirection)
            playerDirection = "up"
            if(self.player.position.y <= self.frame.size.height-250)
            {
                self.player.position.y = self.player.position.y + 150
            }
            
            
        }
        else if (spriteTouched.name == "down") {
            print("DOWN PRESSED")
              print(playerDirection)
            playerDirection = "down"
            if(self.player.position.y >= 150)
            {
                self.player.position.y = self.player.position.y - 150
            }
        }
        else if (spriteTouched.name == "left") {
            playerDirection = "left"
            print("LEFT PRESSED")
            self.player.position.x = self.player.position.x - 50
        }
        else if (spriteTouched.name == "right") {
            playerDirection = "right"
            print("RIGHT PRESSED")
            self.player.position.x = self.player.position.x + 50
        }
        
    }
    
    //---------------------Update function--------------------------------
    var timeOfLastUpdate:TimeInterval?
 
    override func update(_ currentTime: TimeInterval) {
        //update lives and score
        self.livesLabel.text = "Lives: \(self.lives)"
        self.ScoreLabel.text = "Score: \(self.Score)"
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
            enemy.position.x = enemy.position.x + 5
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
        
      //set time for make cats on levels
        if (timeOfLastUpdate == nil) {
            timeOfLastUpdate = currentTime
        }
        // print a message every 3 seconds
        var timePassed = (currentTime - timeOfLastUpdate!)
        if (timePassed >= 3) {
            if(levelOneEnemies.count <= 3 )
            {
            print("HERE IS A MESSAGE!")
            timeOfLastUpdate = currentTime
            // make a cat
            self.makeEnemies()
            }
            if(level2Enemies.count <= 3 )
            {
                print("HERE IS A MESSAGE!")
                timeOfLastUpdate = currentTime
                // make a cat
                self.makeEnemies()
            }
        }
//        if (timePassed >= 5) {
//
//            if (playerDirection != "left" || playerDirection != "right") {
//                playerDirection = "not moving"
//            }
//
//        }

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
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.allowsRotation = false
        
        // give him a category
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.contactTestBitMask = 1
        enemy.physicsBody?.collisionBitMask = 0
        enemy.name = "cat"
        addChild(enemy)
        
        // add enemy to level 1 array
        self.levelOneEnemies.append(enemy);
        
        
        //-------------------second enemy------
        let randX1 = Int(level2.position.x - 300)
        let randY1 = Int(level2.position.y + 70)
        enemy1.position = CGPoint(x:randX1, y:randY1)
        print("enemy position \(randX) \(randY)")
        
        // setup physics for each cat
        enemy1.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy1.physicsBody?.isDynamic = true
        enemy1.physicsBody?.affectedByGravity = false
        enemy1.physicsBody?.allowsRotation = false
        
        // give him a category
        enemy1.physicsBody?.categoryBitMask = 2
        enemy1.physicsBody?.contactTestBitMask = 1
        enemy1.physicsBody?.collisionBitMask = 0
        enemy1.name = "cat"
        addChild(enemy1)
        // add enemy to level 1 array
        self.level2Enemies.append(enemy1)
        
     
    }
    
}

