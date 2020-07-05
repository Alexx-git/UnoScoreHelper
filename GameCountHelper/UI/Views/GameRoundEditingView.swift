//
//  GameRoundEditingView.swift
//  GameCountHelper
//
//  Created by Vlad on 5/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class GameRoundEditingView: BoxView, UITextFieldDelegate {
        
    var editFields = [SkinTextField]()
    var currentField: UITextField?
    var skinGroups = [SkinKey: SkinGroup]()
    func setFieldCount(_ fieldCount: Int) {
        axis = .x
        spacing = 1.0
        insets = UICommon.insets
        createFields(count: fieldCount)
        
    }
    
    private func createFields(count: Int) {
        items = []
        editFields = []
        var prevField: SkinTextField? = nil
        for _ in 0..<count {
            let textField = SkinTextField()
            textField.placeholder = "-"
            textField.borderStyle = .roundedRect
            textField.delegate = self
            textField.removeKeyboard()
            editFields.append(textField)
            textField.font = UIFont.systemFont(ofSize: 32)
            self.items.append(textField.boxed)
            prevField?.bxPinWidth(0.0, to: textField)
            prevField = textField
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentField = textField
        return true
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup])
    {
        
        skinGroups = groups
        //skinStyle = groups[.label]?.styleForState(.normal)
        updateSkin()
    }
    
    func updateSkin()
    {
        let skinStyle = skinGroups[.textField]?.styleForState(.normal)
        for tf in self.editFields {
            tf.setSkinStyle(skinStyle)
        }
    }
}
