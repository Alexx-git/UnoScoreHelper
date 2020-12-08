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
    
    let boxView = BoxView()
        
    let avatarView = AvatarView()
    
    let fieldView = BoxView(insets: .all(8.0))
    
    let textField = SkinTextField()
    
    let saveButton = SkinButton()
    
    var keyboardAvoidingBottomConstraint: NSLayoutConstraint?
        
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
        
        if name.count == 0 {
            showInfoAlert(title: "Error", message: "Name must have at least one character")
            return
        }

        let temp = Player.player(with: name, existing: player)
        if temp == nil {
            showInfoAlert(title: "Error", message: "Player with this name already exists")
        } else {
            player = temp
            player!.image = image
            player!.saveImage()
            viewContext.saveIfNeed()
            self.handler(player!)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.items = [scrollView.boxed]
        let constraints = scrollView.addBoxItem(boxView.boxed)
        print("cons: \(constraints)")
//        keyboardAvoidingBottomConstraint = constraints[3]
        fieldView.items = [textField.boxed]
        scrollView.bxPin(.width, to: .width, of: boxView, pin: .zero)
        boxView.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        boxView.spacing = 20.0
        boxView.items = [
            avatarView.boxed.centerX(),
            fieldView.boxed,
            saveButton.boxed.bottom(>=16.0)
        ]
        image = player?.image
        avatarView.imageView.image = image ?? profileImage
        avatarView.bxSetSize(avatarSize)
        avatarView.layer.cornerRadius = avatarSize.width * 0.5
        avatarView.button.onClick = { [unowned self] btn in
            self.avatarButtonPressed(sender: btn)
        }

        avatarView.imageView.layer.cornerRadius = avatarSize.width * 0.5
        avatarView.imageView.clipsToBounds = true
        
        saveButton.layer.cornerRadius = 10.0
        saveButton.setTitle("Save".ls)
        saveButton.onClick = { [unowned self] btn in
            self.savePlayer()
        }
        
        textField.text = player?.name
        textField.placeholder = "Player name".ls
        textField.font = UIFont.systemFont(ofSize: 20)
        fieldView.layer.cornerRadius = 8.0
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textField.becomeFirstResponder()

        setupMenuItems()
    }
    
    func setupMenuItems() {
        topBarView.titleLabel.text = "Edit player".ls
        topBarView.leftButton.setImage(UIImage.template("back"))
        topBarView.leftButton.contentEdgeInsets = .allX(8.0)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        print("keyboardViewEndFrame: \(keyboardViewEndFrame)")
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset.bottom = 0.0
            scrollView.setContentOffset(.zero, animated: true)
        } else {
            scrollView.contentInset.bottom = keyboardViewEndFrame.height
            let frame = textField.convert(textField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        if let brush = skin.avatar.textDrawing?.brush {
            avatarView.setBrush(brush)
        }
        fieldView.setBrush(skin.editableNumbers.styleForState(.selected)?.box)
        textField.setSkinStyle(skin.text)
//        textField.setSkinStyle(skin.h1)
        
        saveButton.setSkinGroups([.button: skin.keyStyles])
    }

}
