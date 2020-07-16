//
//  PlayerTableViewCell.swift
//  GameCountHelper
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class PlayerTableViewCell: BaseTableViewCell {
    
    let avatarView = UIImageView.newAutoLayout()
    let label = SkinLabel.newAutoLayout()
    let removeButton = SkinButton.newAutoLayout()
    let imgSide: CGFloat = 60.0
    var avatar: UIImage? = nil {
        didSet {
            avatarView.image = avatar
            updateItems()
        }
    }
    var showRemoveButton: Bool = true {
        didSet {
            updateItems()
        }
    }

    override func setup() {
        super.setup()
        boxView.insets.left = 0.0
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        avatarView.layer.cornerRadius = imgSide * 0.5
        avatarView.clipsToBounds = true
        removeButton.contentEdgeInsets = .allX(16.6)
//        removeButton.backgroundColor = .red
        updateItems()
    }
    
    func updateItems() {
        boxView.optItems = [
            removeButton.boxed.centerY().height(40.0).right(-16.0).useIf(showRemoveButton),
            avatarView.boxed.left(16.0).width(imgSide).height( (==imgSide).withPriority(.defaultHigh)).right(-8.0).useIf(avatar != nil),
            label.boxed.left(16.0).right(>=8.0).centerY()
        ]
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        removeButton.setSkinGroups(groups)
        label.setSkinGroups(groups)
        if let brush = groups[.image]?.styleForState(.normal)?.textDrawing?.brush {
            avatarView.setBrush(brush)
        }
    }

}




