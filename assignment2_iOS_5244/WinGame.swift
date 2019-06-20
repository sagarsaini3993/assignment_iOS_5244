//
//  WinGame.swift
//  assignment2_iOS_5244
//
//  Created by MacStudent on 2019-06-20.
//  Copyright © 2019 MacStudent. All rights reserved.
//

//
//  GameScene.swift
//  Test34-S19
//
//  Created by MacStudent on 2019-06-19.
//  Copyright © 2019 rabbit. All rights reserved.
//

import SpriteKit
import GameplayKit

class WinGame: SKScene {

    override func didMove(to view: SKView) {
        print("Loaded level 2")
        
    }
    var timeOfLastUpdate:TimeInterval?
    var restart: Int = 0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //set time for make cats on levels
        if (timeOfLastUpdate == nil) {
            timeOfLastUpdate = currentTime
        }
        // print a message every 3 seconds
        var timePassed = (currentTime - timeOfLastUpdate!)
        if (timePassed >= 1) {
            restart = 1
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if (touch == nil) {
            return
        }
        else{
            if(restart == 1)
            {
                let scene = SKScene(fileNamed:"GameScene")
                scene!.scaleMode = .aspectFill
                view?.presentScene(scene!)
            }
        }
        
        let location = touch!.location(in:self)
        let node = self.atPoint(location)
        
        
    }
}
