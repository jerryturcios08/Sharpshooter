//
//  GameScene.swift
//  Sharpshooter
//
//  Created by Jerry Turcios on 1/24/20.
//  Copyright © 2020 Jerry Turcios. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var ammoCountLabel: SKLabelNode!
    var reloadButton: SKSpriteNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var timeLeft = 60 {
        didSet {
            timerLabel.text = "Time Left: \(timeLeft)"

            if timeLeft == 10 {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {
                    [weak self] _ in

                    self?.timerLabel.isHidden.toggle()
                }
            }
        }
    }

    var numberOfClipsRemaining = 6 {
        didSet {
            ammoCountLabel.text = "Ammo left: \(numberOfClipsRemaining)"

            switch numberOfClipsRemaining {
            case 3:
                ammoCountLabel.fontColor = .yellow
            case 2:
                ammoCountLabel.fontColor = .orange
            case 1:
                ammoCountLabel.fontColor = .red
            case 0:
                ammoCountLabel.fontColor = .red

                ammoTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {
                    [weak self] _ in

                    self?.ammoCountLabel.isHidden.toggle()
                }

                reloadButton.removeFromParent()
                reloadButton = SKSpriteNode(imageNamed: "Reload Button")
                reloadButton.name = "Reload"
                reloadButton.position = CGPoint(x: 920, y: 100)
                reloadButton.size = CGSize(width: 100, height: 100)
                addChild(reloadButton)
            default:
                ammoCountLabel.fontColor = .white
            }
        }
    }

    var nodeTimer: Timer?
    var gameTimer: Timer?
    var ammoTimer: Timer?

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background")
        background.name = "Background"
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0

        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x: 16, y: 720)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
        timeLeft = 60

        ammoCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        ammoCountLabel.position = CGPoint(x: 1000, y: 720)
        ammoCountLabel.horizontalAlignmentMode = .right
        addChild(ammoCountLabel)
        numberOfClipsRemaining = 6

        reloadButton = SKSpriteNode(imageNamed: "Reload Button Disabled")
        reloadButton.name = "Reload"
        reloadButton.position = CGPoint(x: 920, y: 100)
        reloadButton.size = CGSize(width: 100, height: 100)
        addChild(reloadButton)

        nodeTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(createTarget),
            userInfo: nil,
            repeats: true
        )

        // Decrements the amount of time left in the game
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in

            self?.timeLeft -= 1

            if self!.timeLeft <= 10 {
                self?.timerLabel.fontColor = .red
            }
        }
    }

    @objc func createTarget() {
        // Sets the appearance and velocity of a target using a random element
        let height = [620, 440, 260].randomElement()!
        var velocity = [400, 600].randomElement()!
        let size = [75, 150].randomElement()!
        let type = ["Good Target", "Bad Target"].randomElement()!

        let targetTexture = SKTexture(imageNamed: type)
        let targetNode = SKSpriteNode(texture: targetTexture)
        targetNode.name = type

        // Sets the size of the target
        targetNode.size = CGSize(width: size, height: size)

        // Handles the target's initial position and velocity if they are in the second row
        if height == 440 {
            targetNode.position = CGPoint(x: 1100, y: height)
            velocity = -velocity
        } else {
            targetNode.position = CGPoint(x: -100, y: height)
        }

        let nodeWidth = targetNode.size.width
        let nodeHeight = targetNode.size.height

        targetNode.physicsBody = SKPhysicsBody(circleOfRadius: max(nodeWidth / 2, nodeHeight / 2))
        targetNode.physicsBody?.velocity = CGVector(dx: velocity, dy: 0)
        targetNode.physicsBody?.affectedByGravity = false

        addChild(targetNode)
    }

    override func update(_ currentTime: TimeInterval) {
        // Checks if time has run out to perform "game over" actions
        if timeLeft == 0 {
            // Invalidates all timers
            nodeTimer?.invalidate()
            gameTimer?.invalidate()

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                [weak self] in

                // Removes all nodes after five seconds
                self?.removeAllChildren()

                // Re-adds the background
                let background = SKSpriteNode(imageNamed: "Background")
                background.name = "Background"
                background.position = CGPoint(x: 512, y: 384)
                background.zPosition = -1
                self?.addChild(background)

                // Creates final result UI elements
                let gameOverLabel = SKLabelNode()
                gameOverLabel.fontName = "American Typewriter"
                gameOverLabel.fontSize = 50
                gameOverLabel.fontColor = .black
                gameOverLabel.text = "GAME OVER"
                gameOverLabel.position = CGPoint(x: 512, y: 100)
                self?.addChild(gameOverLabel)

                let finalScoreLabel = SKLabelNode()
                finalScoreLabel.fontName = "Chalkduster"
                finalScoreLabel.text = "Final score: \(self!.score)"
                finalScoreLabel.position = CGPoint(x: 512, y: 240)
                self?.addChild(finalScoreLabel)
            }

            return
        }

        // Removes the targets that leave the screen
        for node in children {
            if node.position.x < -300 || node.position.x > 1200 {
                node.removeFromParent()
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        for node in tappedNodes {
            // Plays an appropriate sound based on remaining ammo
            if numberOfClipsRemaining == 0 {
                run(SKAction.playSoundFileNamed("dryfire.mp3", waitForCompletion: false))
            } else if timeLeft > 0 && numberOfClipsRemaining > 0 {
                run(SKAction.playSoundFileNamed("gunfire.mp3", waitForCompletion: false))
            }

            // Performs an action based on the node touched and exits the method
            if node.name == "Reload" && numberOfClipsRemaining == 0 && timeLeft > 0 {
                numberOfClipsRemaining = 6
                run(SKAction.playSoundFileNamed("reload.mp3", waitForCompletion: false))

                ammoTimer?.invalidate()
                ammoCountLabel.isHidden = false

                reloadButton.removeFromParent()
                reloadButton = SKSpriteNode(imageNamed: "Reload Button Disabled")
                reloadButton.name = "Reload"
                reloadButton.position = CGPoint(x: 920, y: 100)
                reloadButton.size = CGSize(width: 100, height: 100)
                addChild(reloadButton)

                return
            } else if node.name == "Good Target" && numberOfClipsRemaining > 0 && timeLeft > 0 {
                if node.frame.size.height > 100 {
                    score += 2
                } else {
                    score += 5
                }
                numberOfClipsRemaining -= 1

                // Creates the spark particle effect when a target is hit
                if let spark = SKEmitterNode(fileNamed: "SparkParticles") {
                    spark.position = node.position
                    addChild(spark)
                }

                node.removeFromParent()
                return
            } else if node.name == "Bad Target" && numberOfClipsRemaining > 0 && timeLeft > 0 {
                score -= 15
                numberOfClipsRemaining -= 1

                // Creates the spark particle effect when a target is hit
                if let spark = SKEmitterNode(fileNamed: "SparkParticles") {
                    spark.position = node.position
                    addChild(spark)
                }

                node.removeFromParent()
                return
            } else if numberOfClipsRemaining > 0 && timeLeft > 0 {
                score -= 5
                numberOfClipsRemaining -= 1
                return
            }
        }
    }
}
