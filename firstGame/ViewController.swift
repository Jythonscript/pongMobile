//
//  ViewController.swift
//  firstGame
//
//  Created by 90302927 on 9/21/18.
//  Copyright © 2018 90302927. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    /*
     TODO
     add main menu
     add sprite to ball
     make paddle "curved" || make ball ricochet slightly random
     
 
     */
    
    @IBOutlet weak var StoryboardSpriteKitView: SKView!
    
    let scene = SKScene(size: CGSize(width: 512, height: 768))
    let WINTEXT = "You Win!"
    let LOSETEXT = "You Lose!"
    let notification = SKLabelNode(text: "")
    
    let SHIPWIDTH = 150
    let SHIPHEIGHT = 50
    let BALLWIDTH  = 50
//    let shipSprite = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 150, height: 50))
    let shipSprite = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 150, height: 50))
    let enemySprite = SKSpriteNode(color: UIColor.red, size: CGSize(width: 150, height: 50))
    let ballSprite = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50, height: 50))
    let testPoint = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: 5, height: 5))
    
    let GAMESTATE_WIN = 1
    let GAMESTATE_NULL = 0
    let GAMESTATE_LOSE = -1
    var gamestate = 0
    
    //offset because (0,0), for example, is offscreen
    let BALLBOUNDSOFFSET = 25
    
    var myShip:ship = ship()
    var enemyShip:enemy = enemy()
    var ball:projectile = projectile()
    
//    let q = DispatchQueue.global()
//    let moveGroup = DispatchGroup.init()
//
//    var moveWorkItem:DispatchWorkItem = DispatchWorkItem {
//        while true {
//            print("In moveWorkItem while loop")
//
//        }
//    }
    
    @IBAction func leftTouchDownButton(_ sender: UIButton) {
        
        self.myShip.setDirection(newDirection: -1)
    }
    
    @IBAction func leftButtonReleased(_ sender: UIButton) {
        self.myShip.setDirection(newDirection: 0)
        shipSprite.position = CGPoint(x: myShip.getPosition(), y: Int(shipSprite.position.y))
    }
    
    @IBAction func leftButtonDragOutside(_ sender: UIButton) {
//        print("Left button drag outside")
        self.myShip.setDirection(newDirection: 0)
    }
    
    @IBAction func rightTouchDownButton(_ sender: UIButton) {

        self.myShip.setDirection(newDirection: 1)
        
    }
    
    @IBAction func rightButtonReleased(_ sender: UIButton) {
        
        shipSprite.position = CGPoint(x: myShip.getPosition(), y: Int(shipSprite.position.y))
        //        shipSprite.position = CGPoint(x: shipSprite.position.x + 10, y: shipSprite.position.y)
        self.myShip.setDirection(newDirection: 0)
        
    }
    
    @IBAction func rightButtonDragOutside(_ sender: UIButton) {
        self.myShip.setDirection(newDirection: 0)
    }
    
    /*
    func initialDelay(seconds:Int) {
        
//        int i
        for i in (1...seconds).reversed() {
            self.notification.text = String(i)
            
        }
    }
     */
    
    func enemyShipThread() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            //initial delay
            for i in (1...3).reversed() {
                self.notification.text = String(i)
                Thread.sleep(forTimeInterval: 1)
            }
            self.notification.text = ""
            
            self.gamestate = self.GAMESTATE_NULL
            
            while true {
                
                //enemy updating
                self.enemyShip.updatePosition(p: self.ball)
                
                //player updating
                self.myShip.updatePosition()
                
                //ball updating and victory / defeat checking
                self.gamestate = self.ball.updatePosition()
                
                if self.gamestate == self.GAMESTATE_WIN {
//                    print("WIN")
                    self.notification.text = self.WINTEXT
//                    self.scene.addChild(self.winText)
                    Thread.sleep(forTimeInterval: 3)
                    self.defaultFields()
                }
                else if self.gamestate == self.GAMESTATE_LOSE {
                    self.notification.text = self.LOSETEXT
                    Thread.sleep(forTimeInterval: 3)
                    self.defaultFields()
                }
                
                //paddle and ball collision
                self.myShip.checkCollision(with: self.ball)
                
                //enemy and ball collision
                self.enemyShip.checkCollision(with: self.ball)
                
                //win / loss checking
//                if self.ball.isWin()
                
                //visual updating
                self.shipSprite.position = CGPoint(x: self.myShip.getPosition(), y: Int(self.shipSprite.position.y))
                self.enemySprite.position = CGPoint(x: self.enemyShip.getPosition(), y: Int(self.scene.size.height) - self.SHIPHEIGHT)
                self.ballSprite.position = CGPoint(x: self.ball.getX(), y: self.ball.getY())
                
//                self.testPoint.position = CGPoint(x: self.myShip.getPosition(), y: Int(self.shipSprite.position.y))
                
                Thread.sleep(forTimeInterval: 0.01)
            }
        }
    }
    
    func defaultFields() {
        
        let randNum = Int.random(in: 0 ... 1)
        
        self.notification.text = ""
        
        shipSprite.position =   CGPoint(x: Int(scene.size.width / 2), y: SHIPHEIGHT)
        enemySprite.position =  CGPoint(x: Int(scene.size.width / 2), y: Int(scene.size.height) - SHIPHEIGHT)
        ballSprite.position =   CGPoint(x: Int(scene.size.width / 2), y: Int(scene.size.height / 2))
        
        self.myShip.setPosition(to: Int(self.scene.size.width / 2))
        self.myShip.setYPosition(to: self.SHIPHEIGHT)
        self.myShip.setBounds(xmin: (self.SHIPWIDTH / 2) + 30, xmax: Int(self.scene.size.width) - ((self.SHIPWIDTH / 2) + 30))
        self.myShip.setWidth(to: self.SHIPWIDTH)
        
        self.enemyShip.setPosition(to: Int(self.scene.size.width / 2))
        self.enemyShip.setYPosition(to: Int(self.scene.size.height) - self.SHIPHEIGHT)
        self.enemyShip.setBounds(xmin: (self.SHIPWIDTH / 2) + 30, xmax: Int(self.scene.size.width) - ((self.SHIPWIDTH / 2) + 30))
        self.enemyShip.setWidth(to: self.SHIPWIDTH)
        
        //initial direction randomizaion
        if randNum == 0 {
            self.ball.setSpeed(xto: -2.0, yto: 2.0)
        }
        else {
            self.ball.setSpeed(xto: 2.0, yto: 2.0)
        }
        
        self.ball.xposition = Double(scene.size.width / 2)
        self.ball.yposition = Double(scene.size.height / 2)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myShip.newShip()
        self.myShip.setObjectDimensions(shipHeight: self.SHIPHEIGHT, ballWidth: self.BALLWIDTH)
        
        self.enemyShip.newEnemy()
        
        self.ball.newProjectile(xpos: Double(scene.size.width / 2), ypos: Double(scene.size.height / 2), leftBound: BALLBOUNDSOFFSET, rightBound: Int(scene.size.width) - BALLBOUNDSOFFSET, victorybound: Int(scene.size.height) - BALLBOUNDSOFFSET, defeatbound: BALLBOUNDSOFFSET)
        
        self.notification.position = CGPoint(x: Int(scene.size.width / 2), y: Int(scene.size.height) - Int(self.SHIPWIDTH * 2))
        
        scene.addChild(shipSprite)
        scene.addChild(enemySprite)
        scene.addChild(ballSprite)
//        scene.addChild(testPoint)
        scene.addChild(notification)
        
        StoryboardSpriteKitView.presentScene(scene)
        
        //set default game values
        self.defaultFields()
        
        //main thread run
        enemyShipThread()

    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        skView.presentScene(scene)
    }
    
    var skView: SKView {
        return view as! SKView
    }
 */

}

