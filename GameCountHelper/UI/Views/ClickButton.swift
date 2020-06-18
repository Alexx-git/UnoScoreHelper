//
//  ClickButton.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class ClickButton : UIButton {
    
    typealias Handler = (UIButton) -> ()

    class func custom() -> Self {
        let btn = Self.init(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }
    
    var onClick: Handler? {
        didSet {
            if onClick != nil {
                removeTarget(nil, action: nil, for: .touchUpInside)
                addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
            }
        }
    }
    
    @objc
    func onButtonClick(sender: UIButton) {
        onClick?(self)
    }

}

class StateUpdatingButton : ClickButton {
    var onStateChange: ClickButton.Handler?
    
    override var isSelected: Bool {
        didSet {
            onStateChange?(self)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            onStateChange?(self)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            onStateChange?(self)
        }
    }
}
