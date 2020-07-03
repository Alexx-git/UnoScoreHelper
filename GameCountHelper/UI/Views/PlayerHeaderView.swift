//
//  PlayerHeaderView.swift
//  GameCountHelper
//
//  Created by Vlad on 7/1/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class PlayerHeaderView: BoxView, RowElement {
    
    
    
    var image: UIImage? = nil {
        didSet {
            avatarView.imageView.image = image
            updateItems()
        }
    }

    let avatarView = AvatarView()
    let label: SkinLabel? = SkinLabel()
    
    func updateItems() {
        optItems = [
            avatarView.boxed.centerX().width(<=60.0).useIf(image != nil),
            label!.boxed.top(>=0.0)
        ]
    }

}
