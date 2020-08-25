//
//  EditRoundViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 6/7/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class EditRoundViewController: TopBarViewController, UITextFieldDelegate {
    
    typealias LabelTapHandler = (SkinLabel) -> Void
    
    typealias OkHandler = ([Int])->(Void)
    
    var onOk: OkHandler?
    
    var tapHandler: LabelTapHandler?
    
    var roundNumber: Int = 0
    
    var values: [Int]?

    var players = [Player]()
    
    var nameLabels = [SkinLabel]()
    
    var editLabels = [SkinLabel]()
    
    var roundBoxView = BoxView()
    
    var listBoxView = BoxView()
    
    let numPadView = NumPadInputView()
    
    var currentLabel: SkinLabel?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let ownSize = view.bounds.size
        var rowCount = 1
        if ownSize.height > ownSize.width * 1.5 {
            rowCount = 4
        }
        else if ownSize.height > ownSize.width * 0.75 {
            rowCount = 2
        }
        numPadView.rowCount = rowCount
    }
    
    func setupMenuItems() {
        topBarView.titleLabel.text = "Round \(roundNumber) scores"
        topBarView.leftButton.setImage(UIImage.template("back"))
        topBarView.leftButton.contentEdgeInsets = .allX(8.0)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.cancelButtonClicked()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuItems()
        roundBoxView.insets = .all(16.0)
        roundBoxView.spacing = 16.0
        contentBoxView.items = [roundBoxView.boxed.bottom(>=0.0)]
        let scrollView = UIScrollView()
        scrollView.addBoxItem(listBoxView.boxed)
        listBoxView.bxPinHeight(.zero, to: scrollView).priority = .defaultLow
        listBoxView.bxPinWidth(.zero, to: scrollView)
        numPadView.setupWithHandler { [unowned self] btnType in
            switch btnType {
                case .num(let value): self.editLabelNumPadClicked("\(value)")
                case .delete: self.editLabelBackSpaceClicked()
                case .ok: self.newRoundButtonClicked()
                case .cancel: self.cancelButtonClicked()
            }
        }
        roundBoxView.items = [
            scrollView.boxed,
            numPadView.boxed
        ]
        setEditFields(with: players)
        tapHandler = { label in
            self.selectLabel(label)
        }
        let tapRec = ClosureTapGestureRecognizer()
        tapRec.onTap = { [unowned self] rec in
            let point = rec.location(in: self.view)
            for label in self.editLabels {
                let rect = label.convert(label.bounds, to: self.view)
                if rect.contains(point) {
                    self.tapHandler?(label)
//                    self.selectedLabel = label
//                    label.state = .selected
                    break
                }
            }

        }
        view.addGestureRecognizer(tapRec)
        editLabels[0].state = .selected
        currentLabel = editLabels[0]
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(players: [Player]) {
        super.init(nibName: nil, bundle: nil)
        self.players = players
    }
    
    func selectLabel(_ label: SkinLabel) {
        guard label !== currentLabel else {return}
        label.state = .selected
        currentLabel?.state = .normal
        currentLabel = label
    }
    
    private func setEditFields(with players: [Player]) {
        listBoxView.items = []
        nameLabels = []
        editLabels = []
        for (index, player) in players.enumerated() {
            let nameLabel = SkinLabel.newAutoLayout()
            nameLabel.text = player.name
            nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            nameLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
            let editLabel = SkinLabel.newAutoLayout()
            editLabel.font = UIFont.systemFont(ofSize: 32)
            editLabel.textAlignment = .center
            if let value = values?[index] {
                if value == 0 {
                    editLabel.text = "-"
                } else {
                    editLabel.text = "\(value)"
                }
            } else {
                editLabel.text = "-"
            }
            
            editLabel.setContentCompressionResistancePriority(.defaultHigh + 2, for: .horizontal)
            editLabel.bxPinWidth(>=100.0)
            editLabel.layer.cornerRadius = 5.0
            editLabel.clipsToBounds = true
            let playerBoxView = BoxView(axis: .x, spacing: 10.0, insets: .zero)
            playerBoxView.items = [nameLabel.boxed, editLabel.boxed]
            nameLabels.append(nameLabel)
            editLabels.append(editLabel)
            listBoxView.items.append(playerBoxView.boxed)
        }
        let first = nameLabels.first
        for label in nameLabels {
            if label != first {
                label.bxPinWidth(.zero, to: first)
            }
        }
    }
    
    func editLabelNumPadClicked(_ value: String) {
        if let edit = currentLabel {
            
            if edit.text?.count ?? 0 >= GameManager.shared.settings.digitLimit {
                showDigitLimitAlert()
            } else if edit.text == "-" {
                edit.text = value
            } else {
                edit.text = (edit.text ?? "") + value
            }
        }
    }
    
    func editLabelBackSpaceClicked() {
        if let edit = currentLabel {
            if (edit.text?.count ?? 0) < 2 {
                edit.text = "-"
            } else {
                edit.text?.removeLast()
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
    
    override func updateSkin(_ skin: Skin)
    {
        super.updateSkin(skin)
        
        let editableSkinGroups = [SkinKey.label: skin.editableNumbers]
        for label in nameLabels {
            label.setSkinGroups(editableSkinGroups)
        }
//        titleLabel.setSkinStyle(labelStyle)
//        let textFieldStyle = skinGroups[.textField]?.styleForState(.normal)
        for tf in self.editLabels {
            tf.setSkinGroups(editableSkinGroups)
        }
        numPadView.setSkin(skin)
    }
    
    func showDigitLimitAlert() {
        showInfoAlert(title: "Too long!", message: "You may not input values with more than \(GameManager.shared.settings.digitLimit) digits")
    }

}
