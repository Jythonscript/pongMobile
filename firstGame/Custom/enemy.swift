//
//  enemy.swift
//  firstGame
//
//  Created by 90302927 on 9/26/18.
//  Copyright © 2018 90302927. All rights reserved.
//

import Foundation

class enemy: ship {
    
    func newEnemy() {
        super.newShip()
    }
    
    //set enemy direction to projectile
    func followProjectile(p:projectile) {
        if p.getX() > self.getPosition() {
            self.setDirection(newDirection: 1)
        }
        else {
            self.setDirection(newDirection: -1)
        }
    }
    
    //move enemy in direction of ship
    func updatePosition(p:projectile) {
        
        self.followProjectile(p: p)
        
        //check for being very close
        if (abs(self.getPosition() - p.getX()) <= MOVESPEED / 2) {
            self.position = p.getX()
        }
        else {
            position += direction * MOVESPEED / 2
        }
        
        if (position < leftBound) {
            position = leftBound
        }
        if (position > rightBound) {
            position = rightBound
        }
    }
    
    override func checkCollision(with:projectile) {
        if abs(self.getPosition() - with.getX()) < (self.width / 2) + 1 {
            //            print ("x aligned")
            if (abs((self.yPosition - 25) - with.getY() - 25) < abs(Int(with.getYSpeed()))) { //check vertical collision
                //^ 25 = SHIPHEIGHT / 2
                //                print ("x and y aligned")
                with.ySpeed = with.ySpeed * -1.0
                with.yposition = Double(self.yPosition - 50)
                with.speedUp()
            }
        }
    }//end checkCollision
    
}
