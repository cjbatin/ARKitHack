//
//  HighscoresManager.swift
//  ARNinja
//
//  Created by Christopher Batin on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation

class HighscoresManager : HighscoresProtocol {
    
    func updateScores(newScore: Int) {
        //Get the highscores
        let highScores = getHighScores()
        //Find the position
        let newPosition = highScorePosition(array: highScores, highScore: newScore)
        //Add to the scores
        let newHighScores = addHighScore(atIndex: newPosition, array: highScores, withScore: newScore)
        //Save the new high scores
        saveArray(highScores: newHighScores)
    }
    
    func getHighScores() -> [Int] {
        let userDefaults =  UserDefaults.standard
        guard let highScores = userDefaults.array(forKey: "highScores") as? [Int] else{
            return []
        }
        return highScores
    }
    
    func addHighScore(atIndex: Int, array: [Int], withScore: Int) -> [Int] {
        var newArray = array
        newArray.insert(withScore, at: atIndex)
        return newArray
    }
    
    func highScorePosition(array: [Int], highScore: Int) -> Int {
        var position = 0
        for value in array {
            if highScore > value {
                return position
            }
            position += 1
        }
        return position
    }
    
    func saveArray(highScores: [Int]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScores, forKey: "highScores")
        userDefaults.synchronize()
    }
}
