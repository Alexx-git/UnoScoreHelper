//
//  BaseView.swift
//  Crypto
//
//  Created by VLADIMIR on 12/25/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        setupProperties()
        setupSubviews()
        setupConstraints()
        setupOwnConstraints()
    }
    
    func setupProperties() {
    }
    func setupSubviews() {
    }
    func setupConstraints() {
    }
    func setupOwnConstraints() {
    }

}
