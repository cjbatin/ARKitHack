//
//  HighScoreProtocol.swift
//  ARNinja
//
//  Created by Christopher Batin on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation

protocol GameDelegate{
    
    /* This method should save the Score the NSUserDefaults*/
    func didfinishGame(withScore: Int)
}
