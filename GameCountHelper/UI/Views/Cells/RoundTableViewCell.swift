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
        boxView.insets = .zero
        rowView.insets = UIEdgeInsets.allX(12.0).allY(8.0)
        boxView.items = [rowView.boxed]
    }
    
}
