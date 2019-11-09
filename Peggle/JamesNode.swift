//
//  JamesNode.swift
//  Peggle
//
//  Created by James O'Rourke on 09/11/2019.
//  Copyright © 2019 20074556. All rights reserved.
//
//  Custom class to allow me to add extra fields to the ball
//  makes the ball init tidier too

import SpriteKit

class JamesNode: SKSpriteNode {
    var hitBouncer: Bool = false
    var numOfBoxes: Int = 0
    
    let randoNum = RandomCGFloat(min: 0, max: 5)
    let ballArr = ["ballBlue","ballCyan","ballGreen","ballGrey","ballPurple","ballYellow"]
    
    
    init(){
        let texture = SKTexture(imageNamed: ballArr[Int(randoNum)] )
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
