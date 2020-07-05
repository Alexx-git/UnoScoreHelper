//
//  NumPadInputView.swift
//  GameCountHelper
//
//  Created by Vlad on 5/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class NumPadInputView: BoxView, Skinnable {
        
    enum ButtonType {
        case num(value: Int)
        case delete
        case ok
        case cancel
    }
    
    var rowViews = [BoxView]()
//    var numSkinGroups = [SkinKey: SkinGroup]()
    var numButtonsSkinFont: UIFont?
//    let numButtonsTextInsetSize = CGSize(10.0, 10.0)
    typealias Handler = (ButtonType) -> Void
    
    private var numButtons = [SkinButton]()
    let delButton = SkinButton()
    let okButton = SkinButton()
    let cancelButton = SkinButton()
    let btnContentInsets = UIEdgeInsets.allX(8.0).allY(-4.0)
    let numBtnContentInsets = UIEdgeInsets.allX(4.0).allY(0.0)
    var handler: Handler?
    
    var rowCount: Int = 0 {
        didSet {
            updateLayout()
        }
    }
    
    var numBtnWidthFactor: CGFloat = 1.0
    var actBtnWidthFactor: CGFloat = 1.0
    func setupButton(_ btn: SkinButton) {
        btn.contentEdgeInsets = btnContentInsets
        btn.layer.cornerRadius = 5.0
    }
    
    func setupNumButton(_ btn: SkinButton) {
//        btn.contentEdgeInsets = numBtnContentInsets
        btn.layer.cornerRadius = 5.0
    }
    
    

    func setupWithHandler(_ handler: @escaping Handler) {
        self.handler = handler
        axis = .y
        spacing = 8.0
        
        let onNumClick: ClickButton.Handler = { [unowned self] btn in
            self.handler?(.num(value: btn.tag))
        }
        insets = .allY(16.0)
        numButtons = []
        for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0] {
            let btn = SkinButton()
            btn.setTitle("\(i)")
            btn.tag = i
            btn.onClick = onNumClick
            setupNumButton(btn)
            numButtons.append(btn)
        }
        delButton.setTitle("⌫")
        delButton.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        delButton.fontScale = 1.5
        delButton.onClick = { [unowned self] btn in
            self.handler?(.delete)
        }
        setupButton(delButton)
        
        okButton.setTitle("OK".ls)
        okButton.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        okButton.onClick = { [unowned self] btn in
            self.handler?(.ok)
        }
        setupButton(okButton)

        updateLayout()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    func updateLayout() {
        guard numButtons.count > 0 else { return }
        print("updateLayout numpad: \(self)")
        print("rowCount: \(rowCount)")
        rowViews = Array(0..<rowCount).map{_ in BoxView(axis: .x, spacing: 0.0, insets: .zero)}
        if (rowCount == 1) {
            numBtnWidthFactor = 0.068
            actBtnWidthFactor = 0.11
            setRowView(rowViews[0], numIndices: Array(0..<10))
            rowViews[0].items.append(delButton.boxed.left(10.0))
            rowViews[0].items.append(okButton.boxed.left(10.0))
        }
        if (rowCount == 2) {
            numBtnWidthFactor = 0.15
            actBtnWidthFactor = 0.16
            setRowView(rowViews[0], numIndices: Array(0..<5))
            setRowView(rowViews[1], numIndices: Array(5..<10))
            rowViews[0].items.append(.flex(2.0))
            rowViews[0].items.append(delButton.boxed)
            rowViews[1].items.append(.flex(2.0))
            rowViews[1].items.append(okButton.boxed)
        }
        if (rowCount == 4) {
            numBtnWidthFactor = 0.31
            actBtnWidthFactor = 0.31
            setRowView(rowViews[0], numIndices: Array(0..<3))
            setRowView(rowViews[1], numIndices: Array(3..<6))
            setRowView(rowViews[2], numIndices: Array(6..<9))
            setRowView(rowViews[3], numIndices: [9])
            rowViews[3].items.append(.flex(1.0))
            rowViews[3].items.append(delButton.boxed)
            rowViews[3].items.append(.flex(1.0))
            rowViews[3].items.append(okButton.boxed)
            
        }
        items = rowViews.boxed
        okButton.bxPinWidth(*actBtnWidthFactor, to: okButton.superview)
        delButton.bxPinWidth(*actBtnWidthFactor, to: delButton.superview)
    }
    
    func setRowView(_ rowView: BoxView, numIndices: [Int]) {
        rowView.items = []
        for num in numIndices {
            let btn = numButtons[num]
            rowView.items.append(btn.boxed)
            btn.bxPinWidth(*numBtnWidthFactor, to: rowView)
            if num != numIndices.last {
                rowView.items.append(.flex(1.0))
            }
        }
//        print("rowView.items: \(rowView.items)")
    }
    
    func setSkin(_ skin: Skin?)
    {
        if let skin = skin {
            let groups: [SkinKey: SkinGroup] = [.button: skin.keyStyles]
            numButtonsSkinFont = skin.keyStyles.styleForState(.normal)?.textDrawing?.font
            for (index, btn) in self.numButtons.enumerated()
            {
                btn.setSkinGroups(groups)
            }
            delButton.setSkinGroups(groups)
            okButton.setSkinGroups(groups)
//            self.setNeedsLayout()
        }
//        backgroundColor = .green
    }
    
    func updateNumFontScale() {
        if let viewSize = numButtons.first?.frame.size,
        let numFont = numButtonsSkinFont
        {
            print("viewSize: \(viewSize)")
            let keyTextSize = viewSize.sizeWithInsets(numBtnContentInsets)
            print("keyTextSize: \(keyTextSize)")
            numButtons.forEach{
                $0.adjustScaleForFont(numFont, text: "W", rectSize: keyTextSize)
                $0.updateStateTitles()
            }
//            okButton.adjustScaleForFont(numFont, text: "OK", rectSize: keyTextSize)
            print("numButtons.first: \(numButtons.first)")
        }
    }
    
//    override func layoutSubviews() {
////        let ownWidth = frame.size.width
//        super.layoutSubviews()
//        updateNumFontScale()
//    }

}
