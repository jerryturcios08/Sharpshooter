//
//  AboutScene.swift
//  Sharpshooter
//
//  Created by Jerry Turcios on 1/27/20.
//  Copyright © 2020 Jerry Turcios. All rights reserved.
//

import SpriteKit

class AboutScene: GameScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background")
        background.name = "Background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)

        let textGroup = SKSpriteNode()
        textGroup.position = CGPoint(x: 512, y: 384)

        let title = SKLabelNode(text: "This is the about page")
        title.name = "Title"
        title.position = CGPoint(x: 512, y: 384)
        title.zPosition = 1
        addChild(title)

        let backButton = SKSpriteNode(imageNamed: "Main Menu Button")
        backButton.name = "Back"
        backButton.position = CGPoint(x: 512, y: 120)
        backButton.zPosition = 1
        addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            if node.name == "Back" {
                let reveal = SKTransition.flipHorizontal(withDuration: 1)
                let menuScene = MenuScene(size: self.size)
                view?.presentScene(menuScene, transition: reveal)
            }
        }
    }
}
