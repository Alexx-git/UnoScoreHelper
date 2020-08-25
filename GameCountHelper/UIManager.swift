//
//  UIManager.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class UIManager {
        
    init(with window: UIWindow) {
        
        window.makeKeyAndVisible()
        window.backgroundColor = UIColor.clear
        
        let newGameVC = GameSettingsViewController()
        let navCon = UINavigationController.init(rootViewController: newGameVC)
        if let session = GameManager.shared.currentSession {
            GameManager.shared.players = nil
            newGameVC.players = session.players
            let savedGameVC = GameSessionViewController(game: session)
            navCon.pushViewController(savedGameVC, animated: false)
        } else {
            if let players = GameManager.shared.players {
                newGameVC.players = players
            }
        }
        navCon.isNavigationBarHidden = true
        window.rootViewController = navCon
        
    }

}
