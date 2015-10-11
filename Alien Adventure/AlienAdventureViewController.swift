//
//  AlienAdventureViewController.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 7/14/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: - AlienAdventureViewController: UIViewController

class AlienAdventureViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet var spriteKitView: SKView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // create/present AlienAdventureScene (SKScene)
        let scene = AlienAdventureScene(size: CGSize(width: 1024, height: 1024))
        scene.scaleMode = .AspectFill
        scene.physicsWorld.contactDelegate = scene
        scene.anchorPoint = CGPointMake(0.5, 0.5)
        scene.settingsController = self.presentingViewController
        spriteKitView.showsFPS = true
        spriteKitView.presentScene(scene)
    }

    // MARK: UIViewController
    
    override func shouldAutorotate() -> Bool { return true }
    override func prefersStatusBarHidden() -> Bool { return true }
}