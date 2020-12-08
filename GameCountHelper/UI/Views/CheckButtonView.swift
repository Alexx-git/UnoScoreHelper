//
//  CheckBoxView.swift
//  Crypto
//
//  Created by Vlad on 4/18/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import PureLayout
import BoxView

typealias CheckHandler = (CheckButtonView) -> ()

class CheckButtonView: BoxView, DropMenuItem {

    
    var skinKey: SkinKey = .button
    
    var fontScale: CGFloat = 1.0
//    private let boxView = BoxView(axis: .x)
    private let button = StateUpdatingButton()
    private let textLabel = UILabel()
    private let checkLabel = UILabel()
    private let squareView = UIView()
    
    var checked: Bool {
        set { button.isSelected = newValue }
        get {  button.isSelected}
    }
    
    var title: String? {
        set {
            textLabel.text = newValue
            updateState()
        }
        get {  textLabel.text}
    }
    
    var numberOfLines: Int {
        get { return textLabel.numberOfLines }
        set { textLabel.numberOfLines = newValue }
    }

    var onCheck: CheckHandler?
    
    var skinGroup: SkinGroup = [:]
     
    let checkText = " ✓ " //
    
    override func setup() {
        super.setup()
        spacing = 8.0
        axis = .x
        squareView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(squareView)
        items = [
            BoxItem(view: checkLabel),
            BoxItem(view: textLabel)
        ]
//        addSubview(button)
        addBoxItem(button.boxed)
        button.onClick = { [unowned self] btn in
            self.button.isSelected = !self.button.isSelected
            self.onCheck?(self)
        }
        button.onStateChange = { [unowned self] btn in
            self.updateState()
        }
        squareView.bxPin(.left, to: .left, of: checkLabel, pin: ==1.0)
        squareView.bxPin(.right, to: .right, of: checkLabel, pin: ==(-1.0))
        squareView.bxSetAspectFromSize(CGSize(1.0, 1.0))
        squareView.bxPin(.centerY, to: .centerY, of: checkLabel, pin: .zero)
//        squareView.bxPinHeight(==0.0, to: textLabel)
//        checkLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        checkLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(.defaultLow + 10, for: .horizontal)
    }
    
    func setFontScale(_ fontScale: CGFloat) {
        self.fontScale = fontScale
    }
    
    func setSkinGroups(_ groups: SkinKeyGroups) {
        guard let group = groups[skinKey] else { return }
        skinGroup = group
        
        for key in group.keys {
            skinGroup[key]?.scaleFontBy(fontScale)
        }

        updateState()
    }

    func updateState() {
        let state = button.state
        checkLabel.isHidden = !checked
        print("checkLabel.isHidden: \(checkLabel.isHidden)")
        guard let style = skinGroup.styleOrDefaultForState(state.skinState) else {
            return
        }
        if let bgColor = style.box?.fill {
            backgroundColor = bgColor
        }
        if let existingText = textLabel.attributedText?.string ?? textLabel.text {
            textLabel.attributedText = style.attributedString(existingText)
        }
        checkLabel.attributedText = style.attributedString(checkText)
        let squareLayer = squareView.layer
        if let boxBorderColor = style.textDrawing?.brush.fill {
            squareLayer.borderColor = boxBorderColor.cgColor
            squareLayer.borderWidth = 2.5
        }
        if let shadow = style.textDrawing?.brush.shadow {
            squareLayer.shadowColor = shadow.color.cgColor
            squareLayer.shadowRadius = shadow.radius
            squareLayer.shadowOffset = shadow.offset
            squareLayer.shadowOpacity = 1.0
        }
        else {
            squareLayer.shadowOpacity = 0.0
            squareLayer.shadowRadius = 0.0
        }
//        checkLabel.backgroundColor = .red
    }
}
