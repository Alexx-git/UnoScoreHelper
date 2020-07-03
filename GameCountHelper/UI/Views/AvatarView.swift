//
//  AvatarView.swift
//  GameCountHelper
//
//  Created by Vlad on 7/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class AvatarView: BoxView {

    let imageView = UIImageView()
    let button = StateUpdatingButton()
    
    override var frame: CGRect {
        didSet {
            imageView.layer.cornerRadius = frame.width / 2
        }
    }
    
    override var bounds: CGRect {
        didSet {
            imageView.layer.cornerRadius = frame.width / 2
        }
    }

    override func setup() {
    super.setup()
        items = [imageView.boxed]
        addBoxItem(button.boxed)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        bxSetAspectFromSize(CGSize(1.0, 1.0))
    }

}
