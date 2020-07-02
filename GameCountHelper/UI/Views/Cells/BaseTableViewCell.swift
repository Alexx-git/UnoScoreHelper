//
//  BaseTableViewCell.swift
//  GameCountHelper
//
//  Created by Vlad on 5/28/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class BaseTableViewCell: UITableViewCell {

    let boxView = BoxView(axis: .x, spacing: UICommon.spacing, insets: UICommon.insets)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addBoxItem(boxView.boxed)
        backgroundColor = .clear
//        contentView.backgroundColor = .blue
        setup()
    }
    
    func setup() {
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
