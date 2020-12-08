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
    
    var avatarHeight: CGFloat = 60.0
    
    var image: UIImage? = nil {
        didSet {
            avatarView.imageView.image = image
            updateItems()
        }
    }

    let avatarView = AvatarView()
    let label: SkinLabel? = SkinLabel()
    
    func updateItems() {
        print("avatarHeight: \(avatarHeight)")
        if axis == .x {
            optItems = [
                .flex(1.0),
                avatarView.boxed.centerY().height(==avatarHeight).left(5.0).useIf(image != nil),
                label!.boxed.left(5.0).right(5.0),
                .flex(1.0)
            ]
        } else {
            optItems = [
                avatarView.boxed.centerX().height(==avatarHeight).useIf(image != nil),
                label!.boxed.top(>=0.0)
            ]
        }
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        print("managedConstraints: \(managedConstraints)")
//        print("constraints: \(constraints.pretty())")
//        subviews.forEach() {  print("---\($0)---\n\($0.constraints.pretty())")}
    }
}
