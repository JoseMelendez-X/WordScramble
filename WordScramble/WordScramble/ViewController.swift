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
        
        //Add an "+" button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    
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
    
    /* START. The two required tableViewDataSource Methods */
    
    //numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usedWords.count
    }
    
    //cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    /*END -------*/
    
    
    //MARK: promptForAnswer function
    
    func promptForAnswer() {
        
        //Create the alert controller
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        
        //Add a textfield to the alert controller
        ac.addTextField()
        
        //submit action
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        //Add the action to the alert controller
        ac.addAction(submitAction)
        
        //Present the alert
        present(ac, animated: true)
    
    }
    
    //MARK: submit function
    
    func submit(answer: String){
        
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        
        if isPossible(word: lowerAnswer) {
            
            if isOriginal(word: lowerAnswer){
                
                if isReal(word: lowerAnswer){
                    
                    usedWords.insert(answer, at: 0)
                    
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    
                    errorTitle = "Word not recognized"
                    
                    errorMessage = "You can't just make them up, you know!"
                }
            }else {
                
                errorTitle = "Word used already"
                
                errorMessage = "Be orginal!"
            }
        }else {
            
            errorTitle = "Word not possible"
            
            errorMessage = "You can't spell a word form '\(title!.lowercased())'!"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(ac, animated: true)
        
    }
    
    //MARK: All three check functions
    
    func isPossible(word: String) -> Bool {
        
        var tempWord = title!.lowercased()
        
        for letter in word.characters{
            
            if let pos = tempWord.range(of: String(letter)) {
                
                tempWord.remove(at: pos.lowerBound)
                
            } else {
                
                return false
            }
            
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        
        //Checks for spelling errors
        let checker = UITextChecker()
        
        let range = NSMakeRange(0, word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
}

