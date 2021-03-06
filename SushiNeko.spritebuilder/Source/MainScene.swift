import Foundation

enum Side
{
    case Left, Right, None
}
enum GameState
{
    case Title, Ready, Playing, GameOver
}

class MainScene: CCNode
{
    weak var piecesNode: CCNode!
    var pieces: [Piece] = []
    weak var character: Character!
    var pieceLastSide: Side = .Left
    var pieceIndex: Int = 0
    var gameState: GameState = .Title
    weak var restartButton: CCButton!
    weak var lifeBar: CCSprite!
    var addPiecesPosition: CGPoint?
    weak var tapButtons: CCNode!
    var timeLeft: Float = 5
    {
        didSet
        {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float(10)
        }
    }
    weak var scoreLabel: CCLabelTTF!
    var score: Int = 0
    {
        didSet
        {
            scoreLabel.string = "\(score)"
        }
    }
    
    
    override func onEnter()
    {
        //println("START UP THAT MAIN SCENE YO")
        super.onEnter()
        addPiecesPosition = piecesNode.positionInPoints
    }
    
    func didLoadFromCCB()
    {
        //println("START UP THAT MAIN SCENE YO")
        for i in 0..<10
        {
            var piece = CCBReader.load("Piece") as! Piece
            pieceLastSide = piece.setObstacle(pieceLastSide)
            var yPos = piece.contentSizeInPoints.height * CGFloat(i)
            piece.position = CGPoint(x: 0, y: yPos)
            piecesNode.addChild(piece)
            pieces.append(piece)
            userInteractionEnabled = true
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!)
    {
        if gameState == .GameOver { return }
        if(touch.locationInWorld().x < CCDirector.sharedDirector().viewSize().width/2)
        {
            character.left()
        }
        else if(touch.locationInWorld().x > CCDirector.sharedDirector().viewSize().width/2)
        {
            character.right()
        }
        if gameState == .GameOver || gameState == .Title { return }
        if gameState == .Ready { start() }
        character.tap()
        stepTower()
    }
    
    func stepTower()
    {
        var piece = pieces[pieceIndex]
        addHitPiece(piece.side)
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: piece.contentSize.height*10))
        piece.zOrder++
        pieceLastSide = piece.setObstacle(pieceLastSide)
        var movePiecesDown = CCActionMoveBy(duration: 0.15, position: CGPoint(x: 0, y: -piece.contentSize.height))
        piecesNode.runAction(movePiecesDown)
        pieceIndex = (pieceIndex+1)%10
        if isGameOver() { return }
        timeLeft = timeLeft + 0.25
        score++
    }
    
    func isGameOver() -> Bool
    {
        var newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side
        {
            triggerGameOver()
        }
        
        return gameState == .GameOver
    }
    
    func triggerGameOver()
    {
        gameState = .GameOver
        
        var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
        gameOverScreen.score = score
        self.addChild(gameOverScreen)
    }
    
    func restart()
    {
        var mainScene = CCBReader.load("MainScene") as! MainScene
        mainScene.ready()
        
        var scene = CCScene()
        scene.addChild(mainScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    override func update(delta: CCTime)
    {
        if gameState != .Playing { return }
        timeLeft -= Float(delta)
        if timeLeft == 0
        {
            triggerGameOver()
        }
    }
    
    func ready()
    {
        gameState = .Ready
        
        self.animationManager.runAnimationsForSequenceNamed("Ready")
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        tapButtons.runAction(CCActionFadeIn(duration: 0.2))
    }
    
    func start()
    {
        gameState = .Playing
        
        tapButtons.runAction(CCActionFadeOut(duration: 0.2))
    }
    
    func addHitPiece(obstacleSide: Side)
    {
        var flyingPiece = CCBReader.load("Piece") as! Piece
        flyingPiece.position = addPiecesPosition!
        
        var animationName = character.side == .Left ? "FromLeft" : "FromRight"
        flyingPiece.animationManager.runAnimationsForSequenceNamed(animationName)
        flyingPiece.side = obstacleSide
        
        self.addChild(flyingPiece)
    }
    
}
