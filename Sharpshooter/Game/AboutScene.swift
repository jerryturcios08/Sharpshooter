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
        let background = SKSpriteNode(imageNamed: "Background (About)")
        background.name = "Background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)

        let title = SKLabelNode(text: "About Sharpshooter")
        title.name = "Title"
        title.fontName = "Roboto"
        title.fontSize = 40
        title.position = CGPoint(x: 512, y: 480)
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
