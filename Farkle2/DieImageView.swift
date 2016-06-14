//
//  DieImageView.swift
//  Farkle2
//
//  Created by Andrew Bihl on 6/9/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit


protocol DieImageViewDelegate {
    func didSelectDie(die: DieImageView, selected: Bool);
}

class DieImageView: UIImageView, UIGestureRecognizerDelegate {
    var delegate: DieImageViewDelegate?
    var lastLoc: CGPoint?
    var value: Int = 0
    var isActive = true{
        didSet{
            if isActive==true{
                self.alpha = 1.0
            }
            else{
                self.alpha = 0.6
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelect))
        self.gestureRecognizers = [tapRecognizer]
    }
    
    
    func roll() -> Int {
        self.userInteractionEnabled = true
        isActive = true
        value = Int(arc4random_uniform(6)+1)
        self.image = UIImage.init(named: "dieFace\(value)")
        return value
    }
    
    func onSelect(){
        self.isActive = !self.isActive;
        self.delegate?.didSelectDie(self, selected: !self.isActive)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
