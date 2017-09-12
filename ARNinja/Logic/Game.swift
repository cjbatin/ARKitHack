//
//  Game.swift
//  Test
//
//  Created by Atkinson, Sean C on 7/9/17.
//  Copyright © 2017 JPMorganChase. All rights reserved.
//

import Foundation

struct GameDefaults {
    let timeIncrease: TimeInterval = 0.5
    let timeDecrease: TimeInterval = 1
    let startingRemainingTime: TimeInterval = 15
    let mininmumSpawnOdds:UInt32 = 2
    let maxTimeBetweenSpawns: TimeInterval = 5
    let minTimeBetweenSpawns: TimeInterval = 1
}

struct Game {
    /// the defaults that this game shoujld use
    let defaults: GameDefaults

    /// The timeinterval that this game was started or nil if the game has yet to start
    var startTime: TimeInterval? // startTime can "change" if the game is paused

    // the remaining time before game over
    var remainingTime: TimeInterval

    // when something was last spawned, or nil if never
    var lastSpawnedAt: TimeInterval?

    var score: Int = 0
}

extension Game {
    init() {
        self.defaults = GameDefaults()
        self.startTime = nil
        self.remainingTime = defaults.startingRemainingTime
    }
}
