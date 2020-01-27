//
//  MenuScene.swift
//  Sharpshooter
//
//  Created by Jerry Turcios on 1/27/20.
//  Copyright © 2020 Jerry Turcios. All rights reserved.
//

import SpriteKit

class MenuScene: GameScene {
    var startGameButton: SKSpriteNode!
    var aboutButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background")
        background.name = "Background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)

        let title = SKSpriteNode(imageNamed: "Game Title")
        title.name = "Title"
        title.position = CGPoint(x: 512, y: 260)
        title.size = CGSize(width: 568.7, height: 119.3)
        addChild(title)

        startGameButton = SKSpriteNode(imageNamed: "Start Game Button")
        startGameButton.name = "Start"
        startGameButton.position = CGPoint(x: 380, y: 120)
        startGameButton.zPosition = 1
        addChild(startGameButton)

        aboutButton = SKSpriteNode(imageNamed: "About Button")
        aboutButton.name = "About"
        aboutButton.position = CGPoint(x: 640, y: 120)
        aboutButton.zPosition = 1
        addChild(aboutButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            if node.name == "Start" {
                let reveal = SKTransition.crossFade(withDuration: 1)
                let gameScene = GameScene(size: self.size)
                view?.presentScene(gameScene, transition: reveal)
            } else if node.name == "About" {
                let reveal = SKTransition.flipHorizontal(withDuration: 2)
            }
        }
    }
}
