//
//  GameScene.swift
//  FlappyBird
//
//  Created by sujin on 5/11/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    // 초기화
    override func didMove(to view: SKView) {
        let land = SKSpriteNode(imageNamed: "land")
        land.position = CGPoint(x: self.size.width/2, y: 50)
        // 화면에 겹치는 정도..?
        land.zPosition = 3
        self.addChild(land)
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPoint(x: self.size.width/2, y: 100)
        sky.zPosition = 1
        self.addChild(sky)
        
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x: self.size.width/2, y: 100)
        pipeUp.zPosition = 2
        self.addChild(pipeUp)
        
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x: self.size.width/2, y: self.size.height)
        pipeDown.zPosition = 2
        pipeDown.xScale = -1 // x방향으로 180' 회전
        pipeDown.zRotation = .pi // 이미지가 180' 회전 , 위 아래가 뒤집힘
        self.addChild(pipeDown)
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.position = CGPoint(x: self.size.width/2, y: 300)
        ceiling.zPosition = 3
        self.addChild(ceiling)
        
        let bird = SKSpriteNode(imageNamed: "bird")
        bird.position = CGPoint(x: self.size.width/2, y: 200)
        bird.zPosition = 2
        self.addChild(bird)
        
    }
   
}
