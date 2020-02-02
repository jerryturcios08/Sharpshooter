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
        let background = SKSpriteNode(imageNamed: "Background (Alt)")
        background.name = "Background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)

        let title = SKLabelNode(text: "About Sharpshooter")
        title.name = "Title"
        title.fontName = "American Typewriter"
        title.fontSize = 40
        title.position = CGPoint(x: 512, y: 480)
        title.zPosition = 1
        addChild(title)

        let informationParagraph = [
            "Shoot the large green targets for points. Shoot ",
            "the small green targets for extra points. Do not ",
            "shoot the red targets, and do not miss! You have ",
            "sixty seconds each game. You have 6 bullets. The ",
            "reload button gives you 6 more bullets. All game ",
            "assets and source code belong to Jerry Turcios. ",
            "All sounds used belong to soundbible.com.",
        ]

        for (index, yValue) in [410, 380, 350, 320, 290, 260, 230].enumerated() {
            let informationChunk = SKLabelNode()
            informationChunk.text = informationParagraph[index]
            informationChunk.fontName = "American Typewriter"
            informationChunk.fontSize = 24
            informationChunk.position = CGPoint(x: 512, y: yValue)
            informationChunk.lineBreakMode = .byWordWrapping
            informationChunk.zPosition = 1
            addChild(informationChunk)
        }

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
