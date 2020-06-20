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
    
    typealias Handler = (ButtonType) -> Void
    
    private var numButtons = [SkinButton]()
    let delButton = SkinButton()
    let okButton = SkinButton()
    let cancelButton = SkinButton()
    let btnContentInsets = UIEdgeInsets.allX(12.0).allY(4.0)
    var handler: Handler?
    
    func setupButton(_ btn: SkinButton) {
        btn.contentEdgeInsets = btnContentInsets
        btn.layer.cornerRadius = 5.0
    }

    func setupWithHandler(_ handler: @escaping Handler) {
        self.handler = handler
        axis = .x
        spacing = 8.0
        
        let onNumClick: ClickButton.Handler = { [unowned self] btn in
            self.handler?(.num(value: btn.tag))
        }
        insets = UICommon.insets
        numButtons = []
        items = []
        var prevView: UIView?
        for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0] {
            let btn = SkinButton()
            btn.setTitle("\(i)")
            btn.tag = i
            btn.onClick = onNumClick
            setupButton(btn)
            numButtons.append(btn)
            self.items.append(btn.boxZero)
            prevView?.alPinWidth(0.0, to: btn)
            prevView = btn
        }
        delButton.setTitle("⌫")
//        delButton.fontScale = 2.0
//        delButton.contentEdgeInsets = delButton.contentEdgeInsets.allY(-10.0)
        self.items.append(delButton.boxLeft(16.0))
        delButton.onClick = { [unowned self] btn in
            self.handler?(.delete)
        }
        setupButton(delButton)
        
        okButton.setTitle("OK".ls)
        okButton.onClick = { [unowned self] btn in
            self.handler?(.ok)
        }
        setupButton(okButton)
        self.items.append(okButton.boxLeft(16.0))
        
        cancelButton.setTitle("Cancel".ls)
        cancelButton.onClick = { [unowned self] btn in
            self.handler?(.cancel)
        }
        setupButton(cancelButton)
        self.items.append(cancelButton.boxLeft(>=16.0))
    }
    
    func setSkin(_ skin: Skin?)
    {
        if let skin = skin {
//            let keyInsetSize = viewSize - CGSize(10, 10)
//            skin.keyStyles.adjustFontSizeToFitText("W", in: keyInsetSize)
            for (index, btn) in self.numButtons.enumerated()
            {
                btn.setSkinGroups([.button: skin.keyStyles])
            }
            
            delButton.setSkinGroups([.button: skin.keyStyles])
            okButton.setSkinGroups([.button: skin.keyStyles])
//            self.setNeedsLayout()
        }
    }

}
