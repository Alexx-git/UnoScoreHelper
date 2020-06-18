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
        
//    let imageView = UIImageView()
    let avatarButton = ClickButton()
    
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
        let predicate = NSPredicate(format: "name == %@", name)
        
        guard Player.fetch(predicate: predicate, context: viewContext) == nil else {
            //show alert
            return
        }
        if player == nil {
            player = Player.newInstance()
            player!.id = Int64(players.count + 1)
        }
        player!.name = name
        viewContext.saveIfNeed()
        self.handler(player!)
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        contentBoxView.spacing = 20.0
        contentBoxView.items = [
            avatarButton.boxCenterX(),
            textField.boxBottom(>=0.0),
        ]
        avatarButton.setImage(UIImage(named: "profile"), for: .normal)
        avatarButton.autoSetDimensions(to: avatarSize)
        avatarButton.layer.cornerRadius = avatarSize.width * 0.5
        avatarButton.onClick = { [unowned self] btn in
            self.avatarButtonPressed(sender: btn)
        }
//        imageView.image = UIImage(named: "profile")
//        imageView.autoSetDimensions(to: avatarSize)
//        imageView.layer.cornerRadius = avatarSize.width * 0.5
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

}
