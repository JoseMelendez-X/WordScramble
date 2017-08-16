//
//  ViewController.swift
//  WordScramble
//
//  Created by Jose Melendez on 8/15/17.
//  Copyright © 2017 JoseMelendez. All rights reserved.
//

import UIKit
//Import GamePlayKit so that we can use the shuffle method in the startGame() function
import GameplayKit

class ViewController: UITableViewController{
    
    //Array of all the words we have
    var allWords = [String]()
    
    //Array of all the words the user has used
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        /* START. Fill the allWords Array with the words in the start.txt file */
        
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt"){
            
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            
            allWords = ["placeHolder"]
        }
        
        /* END. --------*/
        
        startGame()
    }
    
    //MARK: startGame function
    
    func startGame() {
        
        //Randomize the words in allWords and return the randomized array of strings
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        
        //Sets our view controllers title
        title = allWords[0]
        
        usedWords.removeAll(keepingCapacity: true)
        
        tableView.reloadData()
    }

}

