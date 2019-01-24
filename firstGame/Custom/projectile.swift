//
//  projectile.swift
//  firstGame
//
//  Created by 90302927 on 9/26/18.
//  Copyright © 2018 90302927. All rights reserved.
//

import Foundation

class projectile {
    
    let UP = 1.0
    let STOP = 0.0
    let DOWN = -1.0
    
    let XSPEEDCAP = 6.0
    let YSPEEDCAP = 8.0
    let SPEEDUPINCREMENT = 1.1//multiplier
    
    var xSpeed = 0.0
    var ySpeed = 0.0
    
    var xposition = 0.0
    var yposition = 0.0
    
    //horizontal bounds that are bounced off of
    var leftBound:Int = 0
    var rightBound:Int = 0
    
    //victory (up) and defeat (low) bounds
    var victoryBound:Int = 0
    var defeatBound:Int = 0
    
    //constructor
    func newProjectile(xpos:Double, ypos:Double, leftBound:Int, rightBound:Int, victorybound:Int, defeatbound:Int) {
        
        self.xposition = xpos
        self.yposition = ypos
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.victoryBound = victorybound
        self.defeatBound = defeatbound
    }
    
    func setSpeed(xto:Double, yto:Double) {
        self.xSpeed = xto
        self.ySpeed = yto
    }
    
    func setSpeed(xto:Double) {
        self.xSpeed = xto
    }
    
    //collision
    func collideHorizontal() {
        xSpeed *= -1
    }
    func collideVertical() {
        ySpeed *= -1
        self.speedUp()
    }
    func getXSpeed() -> Double {
        return self.xSpeed
    }
    func getYSpeed() -> Double {
        return self.ySpeed
    }
    
    //movement
    func updatePosition() -> Int {
        xposition += xSpeed
        yposition += ySpeed
        
        //bounds check
        if xposition < Double(self.leftBound) {
            collideHorizontal()
            xposition = Double(self.leftBound)
        }
        if xposition > Double(self.rightBound) {
            collideHorizontal()
            xposition = Double(self.rightBound)
        }
        
        //victory and defeat check
        if (yposition > Double(victoryBound)) {
//            yposition = Double(victoryBound)
            return 1
//            collideVertical()
        }
        if (yposition < Double(defeatBound)) {
            return -1
//            yposition = Double(defeatBound)
//            collideVertical()
        }
        
        return 0
        
    }
    
    //position getters, truncated(?) to int
    func getX() -> Int {
        return Int(self.xposition)
    }
    func getY() -> Int {
        return Int(self.yposition)
    }
    
    func speedUp() {
        xSpeed *= SPEEDUPINCREMENT
        ySpeed *= SPEEDUPINCREMENT
        if xSpeed > XSPEEDCAP {
            xSpeed = XSPEEDCAP
        }
        if ySpeed > YSPEEDCAP {
            ySpeed = YSPEEDCAP
        }
        /*
        //x speedup
        if xSpeed > 0 && xSpeed < XSPEEDCAP {
            xSpeed += SPEEDUPINCREMENT
        }
        else if xSpeed < 0 && xSpeed > XSPEEDCAP * -1 {
            xSpeed -= SPEEDUPINCREMENT
        }
        //y speedup
        if ySpeed > 0 && ySpeed < YSPEEDCAP {
            ySpeed += SPEEDUPINCREMENT
        }
        else if ySpeed < 0 && ySpeed > YSPEEDCAP * -1 {
            ySpeed -= SPEEDUPINCREMENT
        }
 */
    }
    func isLose() -> Bool {
        return self.getY() <= self.defeatBound
    }
    func isWin() -> Bool {
        return self.getY() >= self.victoryBound
    }

}
