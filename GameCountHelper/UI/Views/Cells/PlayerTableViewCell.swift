//
//  PlayerTableViewCell.swift
//  GameCountHelper
//
//  Created by Vlad on 5/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class PlayerTableViewCell: BaseTableViewCell {
    
    let label = SkinLabel()
    let deleteButton = SkinButton()

    override func setup() {
        super.setup()
        boxView.items = [
            label.boxZero,
            deleteButton.boxZero
        ]
        label.textAlignment = .left
    }
    
}




