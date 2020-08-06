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
        if axis == .x {
            optItems = [
                .flex(1.0),
                avatarView.boxed.centerY().height(<=60.0).left(5.0).useIf(image != nil),
                label!.boxed.left(5.0).right(5.0),
                .flex(1.0)
            ]
        } else {
            optItems = [
                avatarView.boxed.centerX().width(<=60.0).useIf(image != nil),
                label!.boxed.top(>=0.0)
            ]
        }
        
    }
}
