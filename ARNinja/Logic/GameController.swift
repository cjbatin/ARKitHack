//
//  GameController.swift
//  Test
//
//  Created by Atkinson, Sean C on 7/9/17.
//  Copyright © 2017 JPMorganChase. All rights reserved.
//

import Foundation


protocol GameControllerDelegate: class {

    func scoreUpdated(to:Int)

    func timeRemainingUpdated(to:TimeInterval)

    func gameDidFinish(withScore:Int)

    func spawn(target:Target)
}

extension GameControllerDelegate {
    // implement if we want a timer
    func timeRemainingUpdated(to:TimeInterval) {}
    func scoreUpdated(to:Int) {}
}

class GameController {

    private weak var delegate: GameControllerDelegate?
    private var game: Game
    private var lastUpdateTime: TimeInterval?
    private let calculator: SpawnCalculator

    init(game:Game, delegate:GameControllerDelegate) {
        self.game = game
        self.delegate = delegate
        self.calculator = SpawnCalculator(gameDefaults: game.defaults)
    }

    func start() {
        guard game.startTime == nil else { return } // game already started
        game.startTime = Date().timeIntervalSince1970
    }

    func tapped() {
        game.remainingTime += game.defaults.timeIncrease
        delegate?.timeRemainingUpdated(to: game.remainingTime)
        
        game.score += 1
        delegate?.scoreUpdated(to: game.score)
    }
    
    func missed() {
        game.remainingTime -= game.defaults.timeDecrease
        delegate?.timeRemainingUpdated(to: game.remainingTime)
    }

    func update() {

        // make sure we've started but not finished
        guard let startTime = game.startTime,
            game.remainingTime > 0 else
        { return }
        
//        print("Remaining Time: \(game.remainingTime); Score: \(game.score)");

        let now = Date().timeIntervalSince1970

        defer {
            self.lastUpdateTime = now
        }
        

        // update the remaining time
        let timeElapsedSinceLastUpdate:TimeInterval
        if let lastUpdateTime = self.lastUpdateTime {
            timeElapsedSinceLastUpdate = now - lastUpdateTime
        } else {
            timeElapsedSinceLastUpdate = 0
        }
     
        game.remainingTime -= timeElapsedSinceLastUpdate

        // make sure they have time left in the game
        guard game.remainingTime > 0 else {
            delegate?.gameDidFinish(withScore: game.score)
            return
        }

        let totalElapsedTime = now - startTime

        let lastSpawnedAt = game.lastSpawnedAt ?? startTime
        let shouldSpawn = calculator.shouldSpawn(
            at: now,
            whenLastSpawnedAt: lastSpawnedAt,
            afterTotalElaspedTime: totalElapsedTime
        )

        if shouldSpawn {
            game.lastSpawnedAt = now
            let target = Target(
                uiStyle: .meercat,
                onTap: {
                    self.game.score += 1
                },
                onMiss: {}
            )
            delegate?.spawn(target: target)
        }

        delegate?.timeRemainingUpdated(to: game.remainingTime)
    }
}
