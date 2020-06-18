//
//  AddPlayerTableViewCell.swift
//  GameCountHelper
//
//  Created by Vlad on 5/23/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class AddPlayerTableViewCell: BaseTableViewCell {

    let plusImageView = UIImageView()
    let label = SkinLabel()
    
    override func setup() {
        super.setup()
        boxView.items = [
            plusImageView.boxZero,
            label.boxRight(>=0.0)
        ]
        label.textAlignment = .left
    }

}
