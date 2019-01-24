//
//  ship.swift
//  firstGame
//
//  Created by 90302927 on 9/25/18.
//  Copyright © 2018 90302927. All rights reserved.
//

import Foundation

class ship {
    
    let MOVESPEED = 6
    
    let LEFT = -1
    let STOP = 0
    let RIGHT = 1
    var SHIPHEIGHT = 0
    var BALLWIDTH = 0
    
    var position:Int = 0
    var yPosition:Int = 0
    var direction:Int = 0
    
    var leftBound:Int = 0   //modified in setBounds
    var rightBound:Int = 100//modified in setBounds
    
    var health:Int = 100//modified in default constructor
    var width = 0
    
    func newShip() {
        direction = STOP
        health = 5
    }
    //direction functions
    func setDirection(newDirection:Int) {
        direction = newDirection
    }
    func getDirection() -> Int {
        return direction
    }
    //position functions
    func getPosition() -> Int {
        return position
    }
    func setPosition(to:Int) {
        position = to;
    }
    func setYPosition(to:Int) {
        self.yPosition = to
    }
    func setWidth(to:Int) {
        self.width = to
    }
    //bounds functions
    func setBounds(xmin:Int, xmax:Int) {
        self.leftBound = xmin
        self.rightBound = xmax
    }
    //ship height function
    func setObjectDimensions(shipHeight:Int, ballWidth:Int) {
        self.SHIPHEIGHT = shipHeight
        self.BALLWIDTH  = ballWidth
    }
    //projectile collision function
    func checkCollision(with:projectile) {
        if abs(self.getPosition() - with.getX()) < ((self.width / 2) + (self.BALLWIDTH / 2)) {
//            print ("x aligned")
            if (abs((self.yPosition + (self.SHIPHEIGHT / 2)) - (with.getY() - (self.BALLWIDTH / 2))) < abs(Int(with.getYSpeed()))) { //check vertical collision
//                print ("x and y aligned")
                with.ySpeed = with.ySpeed * -1.0
                with.yposition = Double(self.yPosition + self.SHIPHEIGHT / 2 + 25)
                with.speedUp()
            }
        }
        
    }
    //updating position function
    func updatePosition() {
        position += direction * MOVESPEED
        if (position < leftBound) {
            position = leftBound
        }
        if (position > rightBound) {
            position = rightBound
        }
    }
    
}
