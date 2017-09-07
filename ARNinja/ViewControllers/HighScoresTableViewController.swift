//
//  HighScoresTableViewController.swift
//  ARNinja
//
//  Created by Christopher Batin on 07/09/2017.
//  Copyright © 2017 Christopher Batin. All rights reserved.
//

import Foundation
import UIKit

class HighScoreTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScores = HighscoresManager().getHighScores()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HighScoreCell
        cell.highScoreLabel.text = "\(indexPath.row + 1).Score: \(highScores[indexPath.row])"
        return cell
    }
}

class HighScoreCell : UITableViewCell {
    @IBOutlet weak var highScoreLabel: UILabel!
    
}
