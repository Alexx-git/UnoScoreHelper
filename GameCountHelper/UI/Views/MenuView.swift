//
//  MenuView.swift
//  GameCountHelper
//
//  Created by VLADIMIR on 2/18/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import UIKit

class MenuView: BaseView, Skinnable {
    let stackView = UIStackView.newAutoLayout()
//    var normalAttributes:Dictionary<NSAttributedString.Key, Any>?
//    var highlightedAttributes:Dictionary<NSAttributedString.Key, Any>?
    var buttonSkinGroup: SkinGroup?
    
    override func setupSubviews() {
        super.setupSubviews()
        self.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 20.0
//        stackView.autoPinEdgesToSuperviewEdges()
        stackView.alToSuperviewWithEdgeValues([.left: 16.0, .right: 16.0])
        stackView.autoMatch(.height, to: .height, of: self, withOffset: -16.0, relation: .lessThanOrEqual)
        stackView.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    @discardableResult
    func addArrangedButton(title: String, target: Any?, action: Selector) -> UIButton
    {
        let button = SkinButton()
        button.setTitle(title)
        stackView.addArrangedSubview(button)
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        button.addTarget(target, action: action, for: .touchUpInside)
        if let buttonSkinGroup = buttonSkinGroup {
            button.setSkinGroups([.button: buttonSkinGroup])
        }
        return button
    }
    
    func setSkin(_ skin:Skin?) {
        buttonSkinGroup = skin?.menuButton
        updateSkin()
    }
    
    func updateSkin() {
        if let buttonSkinGroup = buttonSkinGroup {
            for view in stackView.arrangedSubviews {
                if let btn = view as? SkinButton {
                    btn.setSkinGroups([.button: buttonSkinGroup])
                }
            }
        }
    }
}
