//
//  DivView.swift
//  Crypto
//
//  Created by Vlad on 4/12/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class DivView: BaseView {
    
    var heightConstraint: NSLayoutConstraint?
    
    override func setupConstraints() {
        super.setupConstraints()
        heightConstraint = autoSetDimension(.height, toSize: 2.0)
    }
    
}
