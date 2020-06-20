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
        showDropMenuItems([exitButton], sender: sender)
    }
    
    func exitGame() {
        GameManager.shared.currentSession = nil
        navigationController?.popViewController(animated: true)
    }
    
    func hintButtonPressed(sender: UIButton) {

    }
        
        
    func settingsButtonPressed(sender: UIButton)
    {
        let settings = GameManager.shared.settings
        let button = SkinButton.newAL()
        button.setTitle("Change skin".ls)
        button.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
//            self.navigationController?.pushViewController(SkinsViewController(), animated: true)
            self.clickedNewRoundButton()
            self.shufflePlayersIn(order: self.game.players.reversed())
        }

        let moreButton = SkinButton.newAL()
        moreButton.setTitle("All Settings".ls)
        moreButton.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)

            self.shufflePlayersIn(order: self.game.players.reversed())
        }

        showDropMenuItems([button, moreButton], sender: sender)
    }
     
}
