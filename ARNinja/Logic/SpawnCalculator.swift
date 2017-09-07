//
//  GameLogic.swift
//  Test
//
//  Created by Atkinson, Sean C on 7/9/17.
//  Copyright © 2017 JPMorganChase. All rights reserved.
//

import Foundation
import SceneKit



struct SpawnCommand {
    var target: Target
    var minTime: TimeInterval
}

struct SpawnCalculator {

    let gameDefaults: GameDefaults

    func attemptSpawn() -> Bool {
        //        return true
        // ensure we got a sane value for the odds
        let actualOdds = gameDefaults.mininmumSpawnOdds >= 1 ? gameDefaults.mininmumSpawnOdds : 1
        return arc4random() % actualOdds == 0
    }

    func shouldSpawn(
        at currentTime:TimeInterval,
        whenLastSpawnedAt lastSpawnTime:TimeInterval,
        afterTotalElaspedTime totalElapsedTime:TimeInterval
        ) -> Bool {

        var timeSinceLastSpawn =  currentTime - lastSpawnTime
        if timeSinceLastSpawn < 0 {
            timeSinceLastSpawn = 0
        }

        // check the min/max times
        guard timeSinceLastSpawn > gameDefaults.minTimeBetweenSpawns else { return false }
        guard timeSinceLastSpawn < gameDefaults.maxTimeBetweenSpawns else { return true }

        // if we have gone past the original amount of time we should spawn with a fixed chance every time
        if totalElapsedTime >= gameDefaults.startingRemainingTime {
            return attemptSpawn()
        }

        // otherwise, we should use an inversely proportionate chance to the startTime
        let timeToNextSpawn = gameDefaults.startingRemainingTime / (totalElapsedTime)

        let nextSpawnTime = timeToNextSpawn + timeSinceLastSpawn

        if currentTime > nextSpawnTime {
            return attemptSpawn()
        } else {
            return false
        }
    }
}

