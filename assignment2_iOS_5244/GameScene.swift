//
//  GameScene.swift
//  assignment2_iOS_5244
//
//  Created by MacStudent on 2019-06-17.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var player:SKNode!
    var jumpButton:SKLabelNode!
    var level1 : SKNode!
    var level2 : SKNode!
    var level3 : SKNode!
    var level4 : SKNode!
    
    // GAME STAT SPRITES
    let livesLabel = SKLabelNode(text: "Lives: ")
    let enemy = SKSpriteNode(imageNamed: "enemy")
    
    
    
    
    // GAME STATISTIC VARIABLES
    var lives = 2
    var movingEnemyRight :Bool = true
    
    
    override func didMove(to view: SKView) {
        
        // set boundaries around the scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        //sprites
        self.level1 = self.childNode(withName: "level1")
        self.level2 = self.childNode(withName: "level2")
        self.level3 = self.childNode(withName: "level3")
        self.level4 = self.childNode(withName: "level4")
        // level1.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        self.jumpButton = self.childNode(withName: "jumpButton") as! SKLabelNode
        self.player = self.childNode(withName: "player")
        
        
        
        
        
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
    
    
    func moveShip (moveBy: CGFloat, forTheKey: String) {
        let moveAction = SKAction.moveBy(x: moveBy, y: 0, duration: 1)
        let repeatForEver = SKAction.repeatForever(moveAction)
        let seq = SKAction.sequence([moveAction, repeatForEver])
        
        //run the action on your ship
        player.run(seq, withKey: forTheKey)
    }
    
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
        
        
        if(movingEnemyRight == true)
        {
            let RightMoveAction = SKAction.scaleX(to: +1, duration: 0)
            self.enemy.run(RightMoveAction)
            enemy.position.x =     enemy.position.x + 10;
            if(enemy.position.x >= self.frame.width)
            {
                movingEnemyRight = false
            }
        }
        else if (movingEnemyRight == false){
            
            let leftMoveAction = SKAction.scaleX(to: -1, duration: 0)
            self.enemy.run(leftMoveAction)
            enemy.position.x =     enemy.position.x - 10;
            if(enemy.position.x <= 0)
            {
                movingEnemyRight = true
            }
            
        }
        
//        if (timeOfLastUpdate == nil) {
//            timeOfLastUpdate = currentTime
//        }
//        // print a message every 3 seconds
//        var timePassed = (currentTime - timeOfLastUpdate!)
//        if (timePassed >= 1.5) {
//            print("HERE IS A MESSAGE!")
//            timeOfLastUpdate = currentTime
//            // make a cat
//            self.makeEnemies()
//        }
//
    }
   
    func makeEnemies() {
        // lets add some enemies
        // generate a random (x,y) for the cat
        let randX = Int(level1.position.x )
        let randY = Int(level1.position.y + 70)
        enemy.position = CGPoint(x:randX, y:randY)
        print("enemy position \(randX) \(randY)")
        addChild(enemy)
        
    }
    
}

