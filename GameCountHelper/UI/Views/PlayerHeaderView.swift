//
//  PlayerHeaderView.swift
//  GameCountHelper
//
//  Created by Vlad on 7/1/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class PlayerHeaderView: BoxView {
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
            imageView.layer.cornerRadius = widthConstant / 2
            updateItems()
        }
    }
    
    var widthConstant: CGFloat = 60.0 {
        didSet {
            updateItems()
        }
    }

    let imageView = UIImageView()
    let label = UILabel()
    
    func updateItems() {
        optItems = [
            imageView.boxed.width(widthConstant).height(widthConstant).useIf(image != nil),
            label.boxed
        ]
    }
    
    

}
