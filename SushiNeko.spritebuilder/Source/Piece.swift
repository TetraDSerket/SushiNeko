//
//  Piece.swift
//  SushiNeko
//
//  Created by Varsha Ramakrishnan on 6/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit
import Foundation

class Piece: CCNode
{
    weak var left: CCSprite!
    weak var right: CCSprite!
    
    //sets the sides visible or invisible according to which one was chosen
    var side: Side = .None
    {
        didSet
        {
            left.visible = false
            right.visible = false
            if side == .Right
            {
                right.visible = true
            }
            else if side == .Left
            {
                left.visible = true
            }
        }
    }
    
    func setObstacle(lastSide: Side) -> Side
    {
        //print("IM REALLY FEELING IT")
        if(lastSide == .Right || lastSide == .Left)
        {
            //println(" No Soup For You")
            side = .None
        }
        else
        {
            let rand = CCRANDOM_0_1()*100
            if(rand < 45)
            {
                //println(" Left alone")
                side = .Left
            }
            else if(rand < 55)
            {
                //println(" No soup for none of you")
                side = .None
            }
            else
            {
                //println(" Right you are")
                side = .Right
            }
        }
        return side
    }
}
