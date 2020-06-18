//
//  NewRoundViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 6/7/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class NewRoundViewController: UIViewController, UITextFieldDelegate {
    
    typealias OkHandler = ([Int])->(Void)
    
    var onOk: OkHandler?
    
    var roundNumber: Int = 0

    var players = [Player]()
    
    var nameLabels = [SkinLabel]()
    
    var editLabels = [SkinLabel]()
    
    var currentField: UITextField?
    
    var skinGroups = [SkinKey: SkinGroup]()
    
    var boxView: BoxView {
        return view as! BoxView
    }
    
    var contentBoxView = BoxView()
    let actionBoxView = BoxView(axis: .x, spacing: 1.0, insets: UICommon.insets)
    
    let titleLabel = SkinLabel()
    
    var listBoxView = BoxView()
    
    let numPadView = NumPadInputView()
    
    let newRoundButton = SkinButton.newAL()
    
    let cancelButton = SkinButton.newAL()
    
    override func loadView() {
        view = BoxView(axis: .y, spacing: 5.0, insets: .all(10.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxView.backgroundColor = UIColor(rgb: 0xFFFF00,alpha: 0.5)
        titleLabel.textAlignment = .center
        titleLabel.text = "\(roundNumber) Round scores"
        contentBoxView.backgroundColor = .lightGray
        contentBoxView.insets = .all(16.0)
        contentBoxView.spacing = 16.0
        boxView.items = [contentBoxView.boxBottom(>=200.0)]
        let scrollView = UIScrollView()
        scrollView.addBoxItem(listBoxView.boxZero)
        listBoxView.alPinHeight(.zero, to: scrollView).priority = .defaultLow
        listBoxView.alPinWidth(.zero, to: scrollView)
        contentBoxView.items = [
            titleLabel.boxZero,
            scrollView.boxZero,
            numPadView.boxZero,
            actionBoxView.boxZero
        ]
        actionBoxView.items = [cancelButton.boxRight(>=16.0), newRoundButton.boxZero]
        setEditFields(with: players)

        cancelButton.setTitle("Cancel")
        cancelButton.onClick = {btn in
            self.cancelButtonClicked()
        }
        newRoundButton.setTitle("Ok")
        newRoundButton.onClick = {btn in
            self.newRoundButtonClicked()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(players: [Player]) {
        super.init(nibName: nil, bundle: nil)
        self.players = players
    }
    
    private func setEditFields(with players: [Player]) {
        listBoxView.items = []
        nameLabels = []
        editLabels = []
        for player in players {
            let nameLabel = SkinLabel.newAL()
            nameLabel.text = player.name
            nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            nameLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
            let editLabel = SkinLabel.newAL()
            editLabel.text = "-"
            editLabel.font = UIFont.systemFont(ofSize: 32)
            editLabel.setContentCompressionResistancePriority(.defaultHigh + 2, for: .horizontal)
            editLabel.alPinWidth(>=100.0)
            let playerBoxView = BoxView(axis: .x, spacing: 10.0, insets: .zero)
            playerBoxView.items = [nameLabel.boxZero, editLabel.boxZero]
            nameLabels.append(nameLabel)
            editLabels.append(editLabel)
            listBoxView.items.append(playerBoxView.boxZero)
        }
        let first = nameLabels.first
        for label in nameLabels {
            if label != first {
                label.alPinWidth(.zero, to: first)
            }
        }
    }
    
    func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func newRoundButtonClicked() {
        let values = editLabels.map{Int($0.text ?? "0") ?? 0}
        onOk?(values)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentField = textField
        return true
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup])
    {
        skinGroups = groups
        updateSkin()
    }
    
    func updateSkin()
    {
        let labelStyle = skinGroups[.label]?.styleForState(.normal)
        for label in nameLabels {
            label.setSkinStyle(labelStyle)
        }
        let textFieldStyle = skinGroups[.textField]?.styleForState(.normal)
        for tf in self.editLabels {
            tf.setSkinStyle(textFieldStyle)
        }
    }
    
    

}
