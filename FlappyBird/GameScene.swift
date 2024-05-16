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
        
        // alpha = 투명도
        let backColor = SKColor(red: 81/255, green: 192/255, blue: 201/255, alpha: 1.0)
        self.backgroundColor = backColor
        
        createBird()
        createEnvironment()
        createPipe()
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
        bird.zPosition = Layer.bird  // 화면에 겹치는 정도..? 투명도..?
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
        
        // 3강 무한한 무대 만들기
        /*
         land 반복 출력하게 하기
         environment 에 있는 파일을 atlas에 넣어서 사용한다.
         */
        
        let envAtlas = SKTextureAtlas(named: "Environment")
        let landTexture = envAtlas.textureNamed("land") // atlas에 land라는 sprite 불러오기
        let landRepeatNum = Int(ceil( self.size.width/landTexture.size().width ))
        
        for i in 0...landRepeatNum{
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero // land를 붙이는 기준 , 0.5:중심 , zero:좌측하단기준 , 1:우상단
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y:0)
            land.zPosition= Layer.land
            
            addChild(land)
            
            let landMoveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: 20)
            let landMoveReset = SKAction.moveBy(x: landTexture.size().width, y: 0, duration: 0)
            let landMoveSequence = SKAction.sequence([landMoveLeft, landMoveReset])
            land.run(SKAction.repeatForever(landMoveSequence))
        }
        
        let skyTexture = envAtlas.textureNamed("sky")
        let skyRepeatNum = Int(ceil(self.size.width/skyTexture.size().width))
        
        for i in 0...skyRepeatNum{
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint.zero
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: envAtlas.textureNamed("land").size().height)
            sky.zPosition = Layer.sky
            
            addChild(sky)
            
            let skyMoveLeft = SKAction.moveBy(x: -skyTexture.size().width, y: 0, duration: 40)
            let skyMoveReset = SKAction.moveBy(x: skyTexture.size().width, y: 0, duration: 0)
            let skyMoveSequence = SKAction.sequence([skyMoveLeft, skyMoveReset])
            sky.run(SKAction.repeatForever(skyMoveSequence))
        }
                               
        let ceilingTexture = envAtlas.textureNamed("ceiling")
        let ceilingRepeatNum = Int(ceil(self.size.width / ceilingTexture.size().width))
        
        for i in 0...ceilingRepeatNum{
            let ceil = SKSpriteNode(texture: ceilingTexture)
            ceil.anchorPoint = CGPoint.zero
            ceil.position = CGPoint(x: CGFloat(i) * ceil.size.width, y: self.size.height - ceil.size.height / 2)
            ceil.zPosition = Layer.ceil
            
            addChild(ceil)
            
            let ceilMoveLeft = SKAction.moveBy(x: -ceilingTexture.size().width, y: 0, duration: 3)
            let ceilMoveReset = SKAction.moveBy(x: ceilingTexture.size().width, y: 0, duration: 0)
            let ceilMoveSequence = SKAction.sequence([ceilMoveLeft, ceilMoveReset])
            ceil.run(SKAction.repeatForever(ceilMoveSequence))
        }
        
        /**
         각 이미지의 duration을 다르게 주어 플레이어기준으로 먼 배경은 천천히 지나가고 가까운 배경은 빨리 지나가는 효과를 줄 수 있다.
         */
        
//        let land = SKSpriteNode(imageNamed: "land")
//        land.position = CGPoint(x: self.size.width/2, y: 50)
//        land.zPosition = 3
//        self.addChild(land)
        
//        let sky = SKSpriteNode(imageNamed: "sky")
//        sky.position = CGPoint(x: self.size.width/2, y: 100)
//        sky.zPosition = 1
//        self.addChild(sky)
        
//        let ceiling = SKSpriteNode(imageNamed: "ceiling")
//        ceiling.position = CGPoint(x: self.size.width/2, y: self.size.height)
//        ceiling.zPosition = 3
//        self.addChild(ceiling)
    }
    
    func createPipe(){
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x: self.size.width/2, y: 0)
        pipeDown.zPosition = Layer.pipe
        self.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x: self.size.width/2, y: self.size.height + 100)
        pipeUp.zPosition = Layer.pipe
        pipeUp.xScale = -1 // x방향으로 180' 회전
        pipeUp.zRotation = .pi // 이미지가 180' 회전 , 위 아래가 뒤집힘
        self.addChild(pipeUp)
    }
   
}
