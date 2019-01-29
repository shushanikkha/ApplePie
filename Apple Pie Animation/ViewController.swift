//
//  ViewController.swift
//  Apple Pie Animation
//
//  Created by Shushan Khachatryan on 12/14/18.
//  Copyright © 2018 Shushan Khachatryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var appleImage: [UIImageView]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    var listOfWords = ["apple", "mashroom", "orange", "pepper", "tomato","potato","strawberry"]
    let incorrectMovesAllowed = 7
    var currentGame: Game!
    var totalWins = 0 {
        didSet {
            newRound()
            self.showAlert(forVictory: true)
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
            self.showAlert(forVictory: false)
        }
    }
    
      override  func viewDidLoad() {
        super.viewDidLoad()
        newRound()
        
    }
    
    // MARK: - Methods -
    
    func newRound() {
        if !listOfWords.isEmpty {
        let newWord = listOfWords.removeFirst()
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
        updateUI()
        } else {
            enableLetterButtons(false)
            updateUI()
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func updateUI()  {
        var letters = [String]()
        for letter in currentGame.formattedWord.characters {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        self.correctWordLabel.text = wordWithSpacing
        self.scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
    }
    
    func imageAnimation() {
        UIView.animate(withDuration: 3.0) {
            let rotateTransform = CGAffineTransform(rotationAngle: .pi)
            let translateTranform = CGAffineTransform(translationX: 40, y: 850)
            let comoTransform = rotateTransform.concatenating(translateTranform)
            self.appleImage.removeFirst().transform = comoTransform
        }
    }
    
    
    
    // MARK: - IBActions -
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
            imageAnimation()
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func showAlert(forVictory: Bool) {
        let message = (forVictory ? "You Win" : "You Lose")
        let alert = UIAlertController(title: "Apple Pie", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

