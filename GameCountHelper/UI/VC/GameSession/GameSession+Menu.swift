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
        let editPlayersButton = SkinButton.newAutoLayout()
        editPlayersButton.setTitle("Edit players".ls)
        editPlayersButton.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.navigationController?.popViewController(animated: true)
        }
        showDropMenuItems([exitButton, editPlayersButton], sender: sender)
    }
    
    func exitGame() {
        GameManager.shared.currentSession = nil
        navigationController?.popViewController(animated: true)
    }
        
    func settingsButtonPressed(sender: UIButton)
    {
        let aboutButton = SkinButton()
        aboutButton.setTitle("About".ls)
        aboutButton.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.navigationController?.pushViewController(AboutViewController(), animated: true)
        }
        let changeSkinButton = SkinButton()
        changeSkinButton.setTitle("Change skin".ls)
        changeSkinButton.onClick = { [unowned self] btn in
            self.dropMenuView?.dismiss(animated: false)
            self.navigationController?.pushViewController(SkinsViewController(), animated: true)
        }
        let inPlaceEditCheckButton = CheckButtonView()
        inPlaceEditCheckButton.title = "Edit score in-place".ls
        inPlaceEditCheckButton.checked = GameManager.shared.settings.inPlaceEditing
        inPlaceEditCheckButton.onCheck = { [unowned self] checkView in
            self.dropMenuView?.dismiss(animated: false)
            GameManager.shared.settings.inPlaceEditing = checkView.checked
            self.updateLayout()
            self.updateItems()
        }
        
        showDropMenuItems([aboutButton, changeSkinButton, inPlaceEditCheckButton], sender: sender)
    }
     
}
