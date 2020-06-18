//
//  UITextField+Common.swift
//  GameCountHelper
//
//  Created by Vlad on 5/30/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension UITextField {
    
    func removeKeyboard() {
        self.inputAssistantItem.leadingBarButtonGroups = []
        self.inputAssistantItem.trailingBarButtonGroups = []
        self.inputAccessoryView = UIView(frame: .zero)
        self.inputAccessoryView?.isHidden = true
        self.inputView = UIView(frame: .zero)
        self.inputView?.isHidden = true
        self.reloadInputViews()
    }
}
