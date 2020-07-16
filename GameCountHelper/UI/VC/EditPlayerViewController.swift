//
//  EditPlayerViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/22/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class EditPlayerViewController: TopBarViewController {
    
    typealias Handler = (Player) -> (Void)
    
    let avatarSize = CGSize(200.0, 200.0)
    
    var player: Player?
    
    var image: UIImage?
    
    let profileImage = UIImage(named: "profile")
    
    let scrollView = UIScrollView()
        
    let avatarView = AvatarView()
    
    let textField = SkinTextField()
    
    let saveButton = SkinButton()
        
    var handler: Handler
    
    init(player: Player? = nil, handler: @escaping Handler) {
        self.player = player
        self.handler = handler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func savePlayer() {
        guard let name = textField.text else {return}

        let temp = Player.player(with: name, existing: player)
        if temp == nil {
            showPlayerWithSameNameAlert()
        } else {
            player = temp
            player!.image = image
            player!.saveImage()
            viewContext.saveIfNeed()
            self.handler(player!)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showPlayerWithSameNameAlert() {
        // show alert
    }
    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        contentBoxView.spacing = 20.0
        contentBoxView.items = [
            avatarView.boxed.centerX(),
            textField.boxed,
            saveButton.boxed.bottom(>=16.0)
        ]
        image = player?.image
        avatarView.imageView.image = image ?? profileImage
        avatarView.bxSetSize(avatarSize)
        avatarView.layer.cornerRadius = avatarSize.width * 0.5
        avatarView.button.onClick = { [unowned self] btn in
            self.avatarButtonPressed(sender: btn)
        }
//        imageView.image = UIImage(named: "profile")
//        imageView.autoSetDimensions(to: avatarSize)
        avatarView.imageView.layer.cornerRadius = avatarSize.width * 0.5
        avatarView.imageView.clipsToBounds = true
        
        saveButton.layer.cornerRadius = 10.0
        saveButton.setTitle("Save".ls)
        saveButton.onClick = { [unowned self] btn in
            self.savePlayer()
        }
        
        textField.borderStyle = .roundedRect
        textField.text = player?.name
        textField.placeholder = "Player name".ls
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.becomeFirstResponder()

        setupMenuItems()
    }
    
    func setupMenuItems() {
        topBarView.titleLabel.text = "Edit player".ls
//        topBarView.leftButton.setTitle("Cancel".ls)
        topBarView.leftButton.setImage(UIImage.template("back"))
        topBarView.leftButton.contentEdgeInsets = .allX(8.0)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.navigationController?.popViewController(animated: true)
        }

//        topBarView.rightButton.setTitle("Save".ls)
//        topBarView.rightButton.contentEdgeInsets = .allX(8.0)
//        topBarView.rightButton.onClick = { [unowned self] btn in
//            self.savePlayer()
//        }
    }
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        if let brush = skin.avatar.textDrawing?.brush {
            avatarView.setBrush(brush)
        }
    
        textField.setSkinStyle(skin.editableNumbers.styleForState(.normal))
        
        saveButton.setSkinGroups([.button: skin.keyStyles])
    }

}
