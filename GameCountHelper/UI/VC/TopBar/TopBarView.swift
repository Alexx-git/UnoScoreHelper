//
//  TopBarView.swift
//  Crypto
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class TopBarView: BaseView {
    let barContentView = UIView.newAutoLayout()
    let divView = DivView()
    let leftButton = SkinButton.custom()
    let rightButton = SkinButton.custom()
    let titleLabel = SkinLabel.newAL()
    let centerView = UIView()
    var heightConstraint: NSLayoutConstraint?
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(barContentView)
        addSubview(divView)
        barContentView.addSubview(leftButton)
        barContentView.addSubview(rightButton)
        barContentView.addSubview(centerView)
        centerView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        leftButton.contentHorizontalAlignment = .left
        rightButton.contentHorizontalAlignment = .right
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        let mrg: CGFloat = 16.0
        let gap: CGFloat = 8.0
        barContentView.alToSuperviewWithEdgeValues(.all(0.0, excluding: .bottom))
        divView.alToSuperviewWithEdgeValues(.all(0.0, excluding: .top))
        divView.autoPinEdge(.top, to: .bottom, of: barContentView, withOffset: 0.0)
        centerView.autoMatch(.width, to: .width, of: self, withMultiplier: 0.4)
        centerView.autoAlignAxis(.vertical, toSameAxisOf: self)
        centerView.alToSuperviewWithEdgeValues([.top: 0.0, .bottom: 0.0])
        leftButton.autoAlignAxis(.horizontal, toSameAxisOf: self)
        leftButton.autoPinEdge(toSuperviewEdge: .leading, withInset: mrg)
        leftButton.autoPinEdge(.trailing, to: .leading, of: centerView, withOffset: gap, relation: .greaterThanOrEqual)
        leftButton.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        rightButton.autoAlignAxis(.horizontal, toSameAxisOf: self)
        rightButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: mrg)
        rightButton.autoPinEdge(.leading, to: .trailing, of: centerView, withOffset: gap, relation: .greaterThanOrEqual)
        
        titleLabel.alToSuperviewWithEdgeValues(.all(gap))
        heightConstraint = self.autoSetDimension(.height, toSize: 52.0)
    }

    func setSkin(_ skin: Skin) {
        leftButton.setSkinGroups([.button: skin.barButton])
        rightButton.setSkinGroups([.button: skin.barButton])
        titleLabel.setSkinStyle(skin.barTitle)
        divView.setBrush(skin.divider)
    }
    
}
