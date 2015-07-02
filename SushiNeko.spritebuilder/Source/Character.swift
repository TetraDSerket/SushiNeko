//
//  Character.swift
//  SushiNeko
//
//  Created by Varsha Ramakrishnan on 6/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Character: CCSprite
{
    var side: Side = .Left
    
    func left()
    {
        self.scaleX = 1
        side = .Left
    }
    
    func right()
    {
        self.scaleX = -1
        side = .Right
    }
    
    func tap()
    {
        self.animationManager.runAnimationsForSequenceNamed("Tap")
    }
}
