//
//  MoleGameOverlayScene.swift
//  ARNinja
//
//  Created by Sean Atkinson on 12/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation
import SpriteKit

class MoleGameOverlayScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .clear
        
        scoreLabel = SKLabelNode(text: "Score: -")
        scoreLabel.fontName = "DINAlternate-Bold"
        scoreLabel.fontColor = .black
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: size.width/4, y: 50)
        
        timeLabel = SKLabelNode(text:"Time: -")
        timeLabel.fontName = "DINAlternate-Bold"
        timeLabel.fontColor = .black
        timeLabel.horizontalAlignmentMode = .right

        timeLabel.position = CGPoint(x: (size.width/4)*3, y: 50)

        addChild(scoreLabel)
        addChild(timeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
