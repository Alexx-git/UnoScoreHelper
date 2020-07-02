//
//  GameSessionViewController+Menu.swift
//  Crypto
//
//  Created by Vlad on 4/18/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension GameSessionViewController {
    
    func setupMenuItems() {
        topBarView.leftButton.setImage(UIImage.template("menu"))
        topBarView.leftButton.contentEdgeInsets = .allX(8.0)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.menuButtonPressed(sender: btn)
        }

        topBarView.rightButton.setImage(UIImage.template("settings"))
        topBarView.rightButton.onClick = { [unowned self] btn in
            self.settingsButtonPressed(sender: btn)
        }
    }
    
    func menuButtonPressed(sender: UIButton)
    {
        let exitButton = SkinButton()
        exitButton.setTitle("Exit game".ls)
        exitButton.onClick = { [unowned self] btn in
            self.exitGame()
        }
//        let label = SkinLabel()
//        label.text = "gvhgv"
        showDropMenuItems([exitButton], sender: sender)
    }
    
    func exitGame() {
        GameManager.shared.currentSession = nil
        navigationController?.popViewController(animated: true)
    }
        
    func settingsButtonPressed(sender: UIButton)
    {
        let button = SkinButton.newAutoLayout()
        button.setTitle("Change skin".ls)
        button.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.navigationController?.pushViewController(SkinsViewController(), animated: true)
        }

        let reorderButton = SkinButton.newAutoLayout()
        reorderButton.setTitle("Edit players".ls)
        reorderButton.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.navigationController?.popViewController(animated: true)
        }

        showDropMenuItems([button, reorderButton], sender: sender)
    }
     
}
