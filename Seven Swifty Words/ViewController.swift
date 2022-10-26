//
//  ViewController.swift
//  Seven Swifty Words
//
//  Created by Melis Yazıcı on 23.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]() // store all buttons are currently being tapped by the user to spell their answer
    var solutions = [String]() // for all the possible solutions
    
    var score = 0 { // to hold the player's score
        didSet {
            scoreLabel.text = "Score: \(score)" // synchronize the score value all over the code
        }
    }
    
    var level = 1 // to hold the current level
    
    // Create UI with a custom loadView method
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        // Create the scoreLabel
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside) // when the user press the submit button call submitTapped on the current view controller
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside) // when the user press the clear button call clearTapped on the current view controller
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // draw a thin gray line around the buttons view
        buttonsView.layer.borderWidth = 0.5
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        
        // Add Auto Layout constraints
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        // Add values for the width and height of each button
        let width = 150
        let height = 80
        
        // Create 20 buttons as a 4 by 5 grid
        for row in 0..<4 {
            for column in 0..<5 {
                // creating the buttons
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal) // temporarily give buttons a title
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                // Calculate the frameless button using column and row
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                // Assign it here;
                letterButton.frame = frame
                // Add that to buttonsView;
                buttonsView.addSubview(letterButton)
                // Add it to the letterButtons' array;
                letterButtons.append(letterButton)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTittle = sender.titleLabel?.text else { return } // // adds a safety check to read the title from tapped button
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTittle) // appends that button title to the player’s current answer
        
        activatedButtons.append(sender) // appends the button to the activatedButtons array - activatedButtons array store all buttons are currently being tapped
        sender.isHidden = true // hides the button that was tapped
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return } // read out the answerText from currentAnswer text field
        
        // search through the solutions array for an item and if it finds it, tells its position - find the answer text in the solutions array
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll() // remove all buttons from activated buttons array
            
            // If the user gets an answer correct, it's gonna change the answers label rather than saying "7 LETTERS", it says the correct answer user got
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n") // split up the answersLabel to the new variable splitAnswres
            splitAnswers?[solutionPosition] = answerText // replace the line at the solution position with the solution itself - split answers at the solution position where their word was found and replace seven letters (which is answerText) with the solution itself
            answersLabel.text = splitAnswers?.joined(separator: "\n") // re-join the answres label back together
            
            currentAnswer.text = "" // clear out the currentAnswer text field
            score += 1 // add 1 to the score
            
            // if the score divides into seven evenly (zero left over) means the user finish the level, show a message "Well done"
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp)) // take the user to the next level
                present(ac, animated: true)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1 // add 1 to level
        
        solutions.removeAll(keepingCapacity: true) // remove all items from the solutions array - true because we have several solutions each time
        loadLevel() // call loadLevel() so that a new level file is loaded and shown
        
        for btn in letterButtons {
            btn.isHidden = false // all lettter buttons are visible
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = "" // removes the text from the current answer text field
        
        for btn in activatedButtons {
            btn.isHidden = false // unhides all the activated buttons
        }
        
        activatedButtons.removeAll() // removes all the items from activatedButtons array
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        // Find and load the level string from app bundle
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                // where index represents a consecutive integer starting at zero and line represents an element of the sequence so it will place the item into the line variable and its position into the index variable
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ") // separating its letter groups from its clue
                    let answer = parts[0] // the first part of the split line into "answer"
                    let clue = parts[1] // the second part of the split line into "clue"
                    
                    clueString += "\(index + 1). \(clue)\n" // append the second part of the split line "clue" which is the clue to clueString variable, it will show that clues label
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n" // append the solution word splitted by | to the solutionString
                    solutions.append(solutionWord) // append the solutionsString to solutions array
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits // add all the possible parts of all the words in the game that to the letterBits array
                    
                }
            }
        }
        // because of the extra line break in clueString and solutionsString;
        // removes any letters you specify from the start and end of a string
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // randomize the letter buttons
        letterButtons.shuffle()
        
        // it's going to count through all letter buttons we have
        if letterButtons.count == letterBits.count {
            //  then assign that button's title to the matching bit in the letterBits array
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }


}

