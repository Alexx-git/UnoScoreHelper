//
//  RoundTableViewCell.swift
//  GameCountHelper
//
//  Created by Vlad on 5/14/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class RoundTableViewCell: BaseTableViewCell {
    
    let rowView = RowView()

    override func setup() {
        super.setup()
        self.backgroundColor = .clear
        boxView.items = [rowView.boxZero]
    }
    
}
