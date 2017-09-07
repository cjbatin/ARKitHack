//
//  HighscoresManager.swift
//  ARNinja
//
//  Created by Christopher Batin on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation

protocol HighscoresProtocol {
    
    /* Update Scores with the new score */
    func updateScores(newScore :Int)
    /*Should get the high scores*/
    func getHighScores() -> [Int]
    /* Should add highscore at index, returns a new array of high scores*/
    func addHighScore(atIndex: Int, array: [Int], withScore:Int) -> [Int]
    /* Determines the position in the array where a highscore should sit */
    func highScorePosition(array: [Int], highScore: Int) -> Int
    /* Should save the array somewhere */
    func saveArray(highScores :[Int])
}

