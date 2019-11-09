import SpriteKit
import GameplayKit
class GameScene: SKScene, SKPhysicsContactDelegate {
    var isRed = true
    
    var boxesLeft = 0
    var editLabel: SKLabelNode!
    
    var gameOver: Bool = false
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var scoreLabel: SKLabelNode!
    var ballLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var instructionLabel: SKLabelNode!
    var restartLabel: SKLabelNode!
    var statusLabel: SKLabelNode!
    var bonusLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballsLeft = 5 {
        didSet {
            ballLabel.text = "Balls Left: \(ballsLeft)"
        }
    }
    
    var ballsAlive = 0
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballLabel.text = "Balls Left: 5"
        ballLabel.horizontalAlignmentMode = .right
        ballLabel.position = CGPoint(x: 420, y: 700)
        addChild(ballLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        
        
    }
    
    func endScreen(){
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: 524, y: 380)
        gameOverLabel.name = "gameOver"
        
        statusLabel = SKLabelNode(fontNamed: "Chalkduster")
        if boxesLeft == 0 {
            statusLabel.text = "You Win!!!"
        }else{
            statusLabel.text = "You lose..."
        }
        statusLabel.horizontalAlignmentMode = .center
        statusLabel.position = CGPoint(x: 524, y: 340)
        statusLabel.name = "status"
        
        bonusLabel = SKLabelNode(fontNamed: "Chalkduster")
        bonusLabel.text = "Ball Bonus X \(ballsLeft)"
        bonusLabel.horizontalAlignmentMode = .center
        bonusLabel.position = CGPoint(x: 524, y: 280)
        bonusLabel.name = "ballBonus"
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Restart?"
        restartLabel.horizontalAlignmentMode = .center
        restartLabel.position = CGPoint(x: 524, y: 230)
        restartLabel.name = "restart"
        if ballsLeft > 0 {
        for _ in 1...ballsLeft {
            score += 10
            }
            
        }
        
        addChild(gameOverLabel)
        addChild(restartLabel)
        addChild(statusLabel)
        addChild(bonusLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if gameOver {
            if objects.contains(restartLabel) {
                score = 0
                ballsLeft = 5
                restartLabel.removeFromParent()
                gameOverLabel.removeFromParent()
                statusLabel.removeFromParent()
                bonusLabel.removeFromParent()
                }
                gameOver = false
            }else{
                
            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {
                if ballsAlive == 0 && ballsLeft == 0 {
                    gameOver = true
                    endScreen()
                }
                if editingMode {
                    for item in objects {
                        if item.name == "frank" {
                        item.removeFromParent()
                            boxesLeft -= 1
                            break
                        }else{
                            let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                            let box = SKSpriteNode(color: RandomColor(), size: size)
                            box.zRotation = RandomCGFloat(min: 0, max: 3)
                            box.position = location
                            
                            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                            box.physicsBody?.isDynamic = false
                            box.name = "frank"
                            boxesLeft += 1
                            addChild(box)
                            break
                            
                        }
                    }
                   
                } else {
                    if score == 0 && boxesLeft < 10 {
                        self.instructionLabel = SKLabelNode(fontNamed: "Chalkduster")
                        self.instructionLabel.text = "Please place atleast 10 boxes in editmode"
                        self.instructionLabel.horizontalAlignmentMode = .center
                        self.instructionLabel.position = CGPoint(x: 450, y: 400)
                        self.addChild(self.instructionLabel)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
                            self.instructionLabel.removeFromParent()
                        }
                        
                    }else {
                        if boxesLeft == 0 {
                            gameOver = true
                            endScreen()
                        } else {
                    if ballsLeft > 0 {
                    let ball = JamesNode()
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position.x = location.x
                    ball.position.y = 720
                    ball.name = "ball"
                    addChild(ball)
                    ballsLeft -= 1
                    ballsAlive += 1
                    }
                }
                    }
                
                }
            }
        }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        bouncer.name = "phillMitchell"
        addChild(bouncer)
    }
    
    func hitBouncer(ball: JamesNode){
        if ball.hitBouncer{
            ball.physicsBody?.affectedByGravity = false
            ball.physicsBody?.applyForce(CGVector(dx:0 , dy:-250))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
                ball.physicsBody?.affectedByGravity = true
            }
        }
        ball.hitBouncer = !ball.hitBouncer
    }
    
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: JamesNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball, isRed: false)
            if ball.numOfBoxes >= 2{
                score += 10
            }else{
                score += 1
            }
            
            ballsLeft += 1
            ballsAlive -= 1
        } else if object.name == "bad" {
            destroy(ball: ball, isRed: true)
            ballsAlive -= 1
        }else if object.name == "frank" {
            destroy(box: object)
            boxesLeft -= 1
            ball.numOfBoxes += 1
            score += 1
        }else if object.name == "phillMitchell" {
            hitBouncer(ball: ball)
            
        }
    }
    
    func destroy(ball: SKNode, isRed: Bool) {
        if isRed{
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticlesRed") {
            fireParticles.position = ball.position
            addChild(fireParticles)
            }}else{
            if let fireParticles = SKEmitterNode(fileNamed: "FireParticlesGreen") {
                fireParticles.position = ball.position
                addChild(fireParticles)
            }
            
        }
        
        ball.removeFromParent()
    }
    
    func destroy(box: SKNode) {
        box.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA as! JamesNode, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB as! JamesNode, object: nodeA)
        }
    }
}
