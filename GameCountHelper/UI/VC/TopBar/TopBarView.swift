//
//  TopBarView.swift
//  Crypto
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class TopBarView: BoxView {
    let barContentView = UIView.newAutoLayout()
    let divView = DivView()
    let leftButton = SkinButton.custom()
    let rightButton = SkinButton.custom()
    let titleLabel = SkinLabel.newAutoLayout()
    var heightConstraint: NSLayoutConstraint?
    
    
    
    override func setup() {
        super.setup()
        axis = .x
        titleLabel.textAlignment = .center
//        leftButton.backgroundColor = .red
//        rightButton.backgroundColor = .red
        items = [
            leftButton.boxed.width(>=40.0).height(>=40.0).centerY(),
            titleLabel.boxed.centerX(padding: 8.0),
            rightButton.boxed.width(>=40.0).height(>=40.0).centerY(),
        ]
        self.addBoxItems([divView.boxed.top(nil)], insets: .zero)
    }

    func setSkin(_ skin: Skin) {
        leftButton.setSkinGroups([.button: skin.barButton])
        rightButton.setSkinGroups([.button: skin.barButton])
        titleLabel.setSkinStyle(skin.barTitle)
        divView.setBrush(skin.divider)
    }

}
