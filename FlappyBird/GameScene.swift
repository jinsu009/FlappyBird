//
//  GameScene.swift
//  FlappyBird
//
//  Created by sujin on 5/11/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    // 새 이미지 불러와서 화면에 위치시키기
    var bird = SKSpriteNode()
   
    // 초기화 함수
    override func didMove(to view: SKView) {
        
        // alpha = 투명도
        let backColor = SKColor(red: 81/255, green: 192/255, blue: 201/255, alpha: 1.0)
        self.backgroundColor = backColor
        
        // app 안에서 충돌을 감지하는 명령어
        // SKPhysicsContactDelegate 상속받아야 함
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createBird()
        createEnvironment()
        createInfinitePipe(duration: 4)
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
        
        
        bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: self.size.width/2, y: 350)
        bird.zPosition = Layer.bird  // 화면에 겹치는 정도..? 투명도..?
        
        // 4강 물리적 충돌 적용
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        // | : 합연산
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceil | PhysicsCategory.score
        // 물리적인 변화가 일어나는지 판단 하는 부분
        bird.physicsBody?.collisionBitMask =  PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceil
        bird.physicsBody?.affectedByGravity = true
        // 다른 객체들과 상호작용을 해야하기 때문에 true
        bird.physicsBody?.isDynamic = true
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
            land.zPosition = Layer.land
            
            
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size, center: CGPoint(x:land.size.width / 2,y:land.size.height / 2))
            land.physicsBody?.categoryBitMask = PhysicsCategory.land
            land.physicsBody?.affectedByGravity = false // 중력을 받지 않게 하기 위한 옵션
            land.physicsBody?.isDynamic = false // 물리적 충돌이 일어났을 때 위치가 옮겨지는 현상
            
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
            
            ceil.physicsBody = SKPhysicsBody(rectangleOf: ceil.size, center: CGPoint(x: ceil.size.width / 2, y: ceil.size.height / 2))
            ceil.physicsBody?.categoryBitMask = PhysicsCategory.ceil
            ceil.physicsBody?.affectedByGravity = false
            ceil.physicsBody?.isDynamic = false
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
    
    /*
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
    */
    
    // 물리적 적용을 입힌 pipe 함수
    func createPipe(pipeDistance:CGFloat){
        // 스프라이트 생성
        let envAtlas = SKTextureAtlas(named: "Environment")
        let pipeTexture = envAtlas.textureNamed("pipe")
        
        let pipeDown = SKSpriteNode(texture: pipeTexture)
        pipeDown.zPosition = Layer.pipe
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeDown.physicsBody?.isDynamic = false
        
        let pipeUp = SKSpriteNode(texture: pipeTexture)
        pipeUp.xScale = -1 // 뒤집기
        pipeUp.zRotation = .pi
        pipeUp.zPosition = Layer.pipe
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeUp.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        pipeUp.physicsBody?.isDynamic = false
        
        // 파이프 사이를 지나갈 때 score + 1
        // 파이프 사이에 선을 하나 놓고 새와 선이 접촉 했을 때 가산되는 방법으로 진행
        let pipeCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height : self.size.height))
        pipeCollision.zPosition = Layer.pipe
        pipeCollision.physicsBody?.categoryBitMask = PhysicsCategory.score
        pipeCollision.name = "pipeCollision"
        
        addChild(pipeDown)
        addChild(pipeUp)
        addChild(pipeCollision)
        
        // 스프라이트 배치
        
        // 파이프 다운을 위한 상수 정의
        let max = self.size.height * 0.3
        let xPos = self.size.width + pipeUp.size.width
        let yPos = CGFloat(arc4random_uniform(UInt32(max))) + envAtlas.textureNamed("land").size().height
        let endPos = self.size.width + (pipeDown.size.width * 2)
        
        // xposition : 화면의 바깥쪽에 배치 - 파이프 사이즈 크기만큼 화면 바깥에 배치
        // yposition : max - 화면 높이의 30% , 사이즈 위아래로 랜덤값 지정
        
        pipeDown.position = CGPoint(x: xPos, y: yPos)
        pipeUp.position = CGPoint(x: xPos, y: pipeDown.position.y + pipeDistance + pipeUp.size.height)
        pipeCollision.position = CGPoint(x: xPos, y: self.size.height / 2)
      
        let moveAct = SKAction.moveBy(x: -endPos, y: 0, duration: 6)
        // remove 로 cpu의 부하를 낮춰줌
        let moveSeq = SKAction.sequence([moveAct, SKAction.removeFromParent()])
        
        pipeDown.run(moveSeq)
        pipeUp.run(moveSeq)
        pipeCollision.run(moveSeq)
    }
    
    func createInfinitePipe(duration:TimeInterval){
        let create = SKAction.run {
            [unowned self] in self.createPipe(pipeDistance: 100)
        }
        
        let wait = SKAction.wait(forDuration: duration)
        let actSeq = SKAction.sequence([create, wait])
        run(SKAction.repeatForever(actSeq))
    }
    
    // touch callback
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0) // 속도 reset
        self.bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
    }
    
    
    // contact 에 대한 판정 함수
    func didBegin(_ contact: SKPhysicsContact) {
        // 충돌 순서를 고정하기 위해 body를 두개 생성
        // 이 게임에서는 부딪히는 객체가 새 이기 때문에 하나만 둔다.
        // collideBody 는 새가 아닌 다른 객체를 의미한다.
        var collideBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            collideBody = contact.bodyB
        }else {
            collideBody = contact.bodyA
        }
        
        let collideType = collideBody.categoryBitMask
        switch collideType {
        case PhysicsCategory.land:
            print("land")
        case PhysicsCategory.ceil:
            print("ceil")
        case PhysicsCategory.pipe:
            print("pipe")
        case PhysicsCategory.score:
            print("score")
        default:
            break
        }
    }
   
}
