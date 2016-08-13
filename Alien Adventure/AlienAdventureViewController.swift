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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // create/present AlienAdventureScene (SKScene)
        let scene = AlienAdventureScene(size: CGSize(width: 1024, height: 1024))
        scene.scaleMode = .aspectFill
        scene.physicsWorld.contactDelegate = scene
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.settingsController = self.presentingViewController
        spriteKitView.showsFPS = true
        spriteKitView.presentScene(scene)
    }

    // MARK: UIViewController
    
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }
}
