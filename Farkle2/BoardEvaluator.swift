//
//  BoardEvaluator.swift
//  Farkle2
//
//  Created by Andrew Bihl on 6/9/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class BoardEvaluator: NSObject {
    var didHotDice: Bool = false
    var selectedDice: Array<DieImageView>?
    
    //Evaluates score of dice passed in and sets hotDice if all dice score.
    func evaluateScore(selectedDiceValues: Array<Int>, numberSelected: Int) -> Int {
        didHotDice = false
        if numberSelected==6{
            if !selectedDiceValues.contains(0){
                self.didHotDice = true
                return 1500
            }
        }
        var numberUnscoring = numberSelected
        var numberOfPairs = 0
        var scoreOfSelected = 0
        for i in 0...5{
            let landedAtI = selectedDiceValues[i]
            
            if landedAtI >= 3{
                if i==0{
                    scoreOfSelected += (landedAtI - 2)*(i+1)*1000
                }
                else{
                    scoreOfSelected += (landedAtI - 2)*(i+1)*100
                }
                numberUnscoring -= landedAtI
            }
                
            else{
                if landedAtI==2{
                    numberOfPairs+=1
                }
            
                if i==0{
                    scoreOfSelected += landedAtI*100
                    numberUnscoring -= landedAtI
                }
                else if i==4{
                    scoreOfSelected += landedAtI*50
                    numberUnscoring -= landedAtI
                }
            }
        }
        if (numberOfPairs==3){
            self.didHotDice = true
            return 750
        }
        if (numberUnscoring==0){
            didHotDice = true
        }
        
        return scoreOfSelected
    }
    
    
}
