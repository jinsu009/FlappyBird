//
//  GameScene.swift
//  FlappyBird
//
//  Created by sujin on 5/11/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    // 초기화 함수
    override func didMove(to view: SKView) {
        createBird()
        createEnvironment()
    }
    
    // 2강 애니메이션 파트_0
    // 2. 초기화 함수에 작성했던 코드를 함수로 분리한다.
    func createBird(){
        // 2강 애니메이션 파트_1
        /**
         spriteatlas 를 만들어서 텍스처를 하나씩 가져온다.
         순서대로 기록한 텍스쳐배열을 만든다.
         skaction이라는 명령어로 텍스쳐를 재생한다.
         */
        
        // 스프라이트 아틀라스 초기화
        /**
         asset dir > bird.sprite-atlas dir
         존재하는 파일들을 birdTexture라는 이름의 객체로 인식한다.
         */
        // 애니메이션 만드는 방법 1
        let birdTexture = SKTextureAtlas(named: "Bird")
        
        
        // 새 이미지 불러와서 화면에 위치시키기
        let bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: self.size.width/2, y: 350)
        bird.zPosition = 4  // 화면에 겹치는 정도..? 투명도..?
        self.addChild(bird)
        
        // 2강 애니메이션 파트_2
        // 애니메이션 만드는 방법 1
       /*
        var aniArray = [SKTexture]() // 배열 생성
        for i in 1...birdTexture.textureNames.count{
            aniArray.append(SKTexture(imageNamed: "bird\(i)"))
        }
        // animate with : 애니메이션을 만드는 명령어
        // timePerFrame : frame 당 재생시간
        // skaction 으로 무한히 실행시킨다.
        let flyingAni = SKAction.animate(with: aniArray, timePerFrame: 0.1)
        bird.run(SKAction.repeatForever(flyingAni))
        */
        
        // 애니메이션 만드는 방법 2 _ 씬 에디터 사용
        /**
         기본적으로 생성되는 action.xks 파일은 skaction을 이용한 애니메이션을 지정하는 파일
         */
        // 이미 sks파일에서 무한반복을 하기 때문에 코드에서는 따로 옵션을 주지 않아도 된다.
        guard let flyingBySKS = SKAction(named: "flying") else {return}
        // sks 파일을 옵셔널 형태이기 때문에 느낌표를 사용해서 옵셔널 형식을 제거한다.
        // 여기서는 guard로 불러온다 , 파일이 존재하지 않을경우 그냥 return 
        bird.run(flyingBySKS)
    }
    
    func createEnvironment(){
        let land = SKSpriteNode(imageNamed: "land")
        land.position = CGPoint(x: self.size.width/2, y: 50)
        land.zPosition = 3
        self.addChild(land)
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPoint(x: self.size.width/2, y: 100)
        sky.zPosition = 1
        self.addChild(sky)
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.position = CGPoint(x: self.size.width/2, y: self.size.height)
        ceiling.zPosition = 3
        self.addChild(ceiling)
        
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x: self.size.width/2, y: 0)
        pipeDown.zPosition = 2
        self.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x: self.size.width/2, y: self.size.height + 100)
        pipeUp.zPosition = 2
        pipeUp.xScale = -1 // x방향으로 180' 회전
        pipeUp.zRotation = .pi // 이미지가 180' 회전 , 위 아래가 뒤집힘
        self.addChild(pipeUp)
        
       
    }
   
}
