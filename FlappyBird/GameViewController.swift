//
//  GameViewController.swift
//  FlappyBird
//
//  Created by sujin on 5/11/24.
//

import SpriteKit

class GameViewController: UIViewController {

    /**
     viewController 작성
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks' .. 게임 실행 화면
            let scene = GameScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            // 화면에 표시되는 노드의 순서를 유저가 직접 결정할 수 있지만
            // 그렇게 하지않고 노드의 순서를 compiler에게 할당한다.
            view.ignoresSiblingOrder = true
            
            // 화면에 프레임 숫자 보여주는 옵션
            view.showsFPS = true
            // 화면에 표시되고 있는 노드의 갯수를 보여주는 옵션
            view.showsNodeCount = true
        }
    }
    
    /**
     기기를 회전시켰을 때 화면이 따라서 돌아가도록 하는 옵션
     */
    override var shouldAutorotate: Bool{
        return true;
    }

    /**
     랜드스케이프 모드 , 포트레이드 모드를 어떻게 할 것인지 결정 하는 옵션
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    /**
     스테이터스 바를 보여줄지 말지 결정하는 옵션
     */
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
