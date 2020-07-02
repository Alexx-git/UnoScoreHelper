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
        
    let avatarView = AvatarView()
    
    let textField = UITextField()
        
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
        let players = Player.fetchAllInstances(in: viewContext)
        guard let name = textField.text else {return}
        
        for player in players {
            if (player.name == name) && (player != self.player) {
                //We have another player with same name. Show Alert
                return
            }
        }
        if player == nil {
            player = Player.newInstance()
            player!.id = Int64(players.count + 1)
        }
        player!.name = name
        player!.image = image
        player!.saveImage()
        
        viewContext.saveIfNeed()
        self.handler(player!)
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        contentBoxView.spacing = 20.0
        contentBoxView.items = [
            avatarView.boxed.centerX(),
            textField.boxed.bottom(>=0.0),
        ]
        image = player?.image
        avatarView.imageView.image = image ?? UIImage(named: "profile")
        avatarView.bxSetSize(avatarSize)
        avatarView.layer.cornerRadius = avatarSize.width * 0.5
        avatarView.button.onClick = { [unowned self] btn in
            self.avatarButtonPressed(sender: btn)
        }
//        imageView.image = UIImage(named: "profile")
//        imageView.autoSetDimensions(to: avatarSize)
        avatarView.imageView.layer.cornerRadius = avatarSize.width * 0.5
        avatarView.imageView.clipsToBounds = true
        textField.borderStyle = .roundedRect
        textField.text = player?.name
        textField.placeholder = "Player name".ls
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.becomeFirstResponder()

        setupMenuItems()
    }
    
    func setupMenuItems() {
        topBarView.titleLabel.text = "Edit player".ls
        topBarView.leftButton.setTitle("Cancel".ls)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.navigationController?.popViewController(animated: true)
        }

        topBarView.rightButton.setTitle("Save".ls)
        topBarView.rightButton.onClick = { [unowned self] btn in
            self.savePlayer()
        }
    }
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        if let brush = skin.avatar.textDrawing?.brush {
            avatarView.setBrush(brush)
        }
//        playerCellGroups = [.button: skin.barButton,
//                            .label: skin.h2.normalGroup,
//                            .image: skin.avatar.normalGroup]
    }

}

class AvatarView: BoxView {
    let imageView = UIImageView()
    let button = StateUpdatingButton()
    
    override func setup() {
        super.setup()
        items = [imageView.boxed]
        addBoxItem(button.boxed)
    }
}
