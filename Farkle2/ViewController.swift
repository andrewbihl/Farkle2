//
//  ViewController.swift
//  Farkle2
//
//  Created by Andrew Bihl on 6/9/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DieImageViewDelegate {
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet var dice: [DieImageView]!
    @IBOutlet weak var turnScoreLabel: UILabel!
    @IBOutlet weak var endTurnButton: UIButton!
    let scorer = BoardEvaluator()
    var selectedDice: Array<Int> = Array.init(arrayLiteral: 0,0,0,0,0,0)
    var rollScore: Int = 0
    var turnScore: Int = 0
    var player1Score: Int = 0
    var player2Score: Int = 0
    var isPlayer1Turn: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        endTurnButton.enabled = false
        view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "WoodTexture")!);
        for die in dice{
            die.delegate = self
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    func didSelectDie(die: DieImageView, selected: Bool) {
        if selected{
            selectedDice[die.value-1] += 1
        }
        else{
            selectedDice[die.value-1] -= 1
        }
        var numberSelected = 0
        for diceRolled in selectedDice{
            numberSelected += diceRolled
        }
        rollScore = scorer.evaluateScore(selectedDice, numberSelected: numberSelected)
        if (rollScore>0){
            endTurnButton.enabled = true
        }
        else{
            endTurnButton.enabled = false
        }
        self.turnScoreLabel.text = String(self.turnScore + self.rollScore)
    }
    
    func prepareNewRound()  {
        isPlayer1Turn = !isPlayer1Turn
        turnScore = 0
        rollScore = 0
        endTurnButton.enabled = false
        self.turnScoreLabel.text = String(0)
        for die in dice{
            die.userInteractionEnabled = false
        }
    }
    
    func gameOver(){
        var alertController: UIAlertController
        var okayAction : UIAlertAction
        if isPlayer1Turn{
            alertController = UIAlertController(
                title: "Player 1 Wins!",
                message: nil,
                preferredStyle: .Alert)
            okayAction = UIAlertAction(
                title: "Play Again",
                style: .Default,
                handler: nil)
        }
        else{
            alertController = UIAlertController(
                title: "Player 2 Wins!",
                message: nil,
                preferredStyle: .Alert)
            okayAction = UIAlertAction(
                title: "Play Again",
                style: .Default,
                handler: nil)
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        player1Score = 0
        player2Score = 0
        player1Label.text = "0"
        player2Label.text = "0"
        prepareNewRound()
    }
    
    @IBAction func onEndTurn(sender: AnyObject) {
        if isPlayer1Turn{
            player1Score += turnScore + rollScore
            player1Label.text = String(player1Score)
            if player1Score >= 10000{
                self.gameOver()
            }
        }
        else{
            player2Score += turnScore + rollScore
            player2Label.text = String(player2Score)
            if player2Score >= 10000{
                self.gameOver()
            }
        }
        for die in dice{
            die.isActive = true
        }
        self.prepareNewRound()
    }
    
    func onFarkle(){
        for die in dice{
            die.isActive = true
        }
        self.prepareNewRound()
    }
    
    func onHotDice(result: Int) {
        //onHotDice() aSDFJASDFAJSDK
        turnScore += rollScore + result
        for die in dice{
            die.isActive = true
        }
        rollScore = 0
        endTurnButton.enabled = true
        self.turnScoreLabel.text = String(turnScore)
        for die in dice{
            die.userInteractionEnabled = false
        }
        let alertController: UIAlertController = UIAlertController(
            title: "Hot Dice!",
            message: "All of the rolled dice scored! Go again or end your turn.",
            preferredStyle: .Alert)
        let okayAction = UIAlertAction(
            title: "Okay",
            style: .Default,
            handler: nil)
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onRoll(sender: UIButton) {
        //Array holds at index i the number of dice  that landed with the i+1 face
        
        turnScore += rollScore
        rollScore = 0
        var diceValues: Array<Int> = Array.init(arrayLiteral: 0,0,0,0,0,0)
        selectedDice = Array.init(arrayLiteral: 0,0,0,0,0,0)
        var numberSelected = 0
        for die in dice {
            if (die.isActive){
            //if a 6 is rolled, increment the value at index 5
                let dieValue = die.roll()
                numberSelected += 1
                diceValues[dieValue - 1] += 1
            }
            else{
                die.userInteractionEnabled = false
            }
        }
        let result = scorer.evaluateScore(diceValues, numberSelected: numberSelected)
        if scorer.didHotDice{
            onHotDice(result)
        }
        
        if result==0{
            let alertController: UIAlertController = UIAlertController(
                    title: "Farkle!",
                    message: "None of the rolled dice scored. Your turn is over.",
                    preferredStyle: .Alert)
            let okayAction = UIAlertAction(
                title: "Okay",
                style: .Default,
                handler: {(void) in self.onFarkle()})
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    


}

