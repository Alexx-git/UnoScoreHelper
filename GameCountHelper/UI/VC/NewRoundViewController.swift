//
//  NewRoundViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 6/7/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class NewRoundViewController: BaseViewController, UITextFieldDelegate {
    
    typealias LabelTapHandler = (SkinLabel) -> Void
    
    typealias OkHandler = ([Int])->(Void)
    
    var onOk: OkHandler?
    
    var tapHandler: LabelTapHandler?
    
    var roundNumber: Int = 0

    var players = [Player]()
    
    var nameLabels = [SkinLabel]()
    
    var editLabels = [SkinLabel]()
    
    var skinGroups = [SkinKey: SkinGroup]()
    
    var boxView: BoxView {
        return view as! BoxView
    }
    
    var contentBoxView = BoxView()
    
    let titleLabel = SkinLabel()
    
    var listBoxView = BoxView()
    
    let numPadView = NumPadInputView()
    
    var currentLabel: SkinLabel?
    
    var rowSkinGroups = [SkinKey: SkinGroup]()
    
    override func loadView() {
        view = BoxView(axis: .y, spacing: 5.0, insets: .all(10.0))
    }

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boxView.backgroundColor = UIColor(rgb: 0xFFFF00,alpha: 0.5)
        titleLabel.textAlignment = .center
        titleLabel.text = "Round \(roundNumber) scores"
        contentBoxView.backgroundColor = .lightGray
        contentBoxView.insets = .all(16.0)
        contentBoxView.spacing = 16.0
        boxView.items = [contentBoxView.boxed.bottom(>=0.0)]
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
        contentBoxView.items = [
            titleLabel.boxed,
            scrollView.boxed,
            numPadView.boxed
        ]
        setEditFields(with: players)
        tapHandler = { label in
            guard label !== self.currentLabel else {return}
            label.state = .selected
            self.currentLabel?.state = .normal
            self.currentLabel = label
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
    
    private func setEditFields(with players: [Player]) {
        listBoxView.items = []
        nameLabels = []
        editLabels = []
        for player in players {
            let nameLabel = SkinLabel.newAutoLayout()
            nameLabel.text = player.name
            nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            nameLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
            let editLabel = SkinLabel.newAutoLayout()
            editLabel.text = "-"
            editLabel.font = UIFont.systemFont(ofSize: 32)
            editLabel.textAlignment = .center
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
            if edit.text == "-" {
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
        
        rowSkinGroups = [SkinKey.label: skin.editableNumbers]
        for label in nameLabels {
            label.setSkinGroups(rowSkinGroups)
        }
//        titleLabel.setSkinStyle(labelStyle)
        let textFieldStyle = skinGroups[.textField]?.styleForState(.normal)
        for tf in self.editLabels {
            tf.setSkinGroups(rowSkinGroups)
        }
        numPadView.setSkin(skin)
    }

}
