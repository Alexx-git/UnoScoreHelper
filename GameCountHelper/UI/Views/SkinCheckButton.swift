//
//  SkinCheckButton.swift
//  Crypto
//
//  Created by Vlad on 4/18/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class SkinCheckButton: SkinButton
{    
    var textTitle: String?
    
    override var title: String? {
        textTitle
    }
    
    func titleChecked(_ checked: Bool) -> String {
        if checked {
            return "✓" + (textTitle ?? "")
        }
        else {
            return "□" + (textTitle ?? "")
        }
    }
    
    
    override func setTitle(_ title: String?) {
        textTitle = title
        super.setTitle(titleChecked(false))
        let states: [UIControl.State] = [.selected, [.selected, .highlighted]]
        for state in states {
            let cht = titleChecked(true)
            let skinState = state.skinState
            let attr = skinGroup.styleOrDefaultForState(skinState)?.textDrawing?.textAttributes()
            let attrTitle = NSAttributedString(string: cht, attributes: attr)
            self.setAttributedTitle(attrTitle, for: state)
        }
    }
    
    override func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        guard let group = groups[skinKey] else { return }
        skinGroup = group
        for key in skinGroup.keys {
            skinGroup[key]?.scaleFontBy(fontScale)
        }
        
        let states: [UIControl.State] = [.normal, .highlighted, .selected, [.selected, .highlighted]]
        for state in states {
//            let cState = Skin.State(rawValue:state)?.controlState ?? .normal
            let checked = state.contains(.selected)
            let stateTitle = titleChecked(checked)
            let style = skinGroup.styleOrDefaultForState(state.skinState)
            let attr = style?.textDrawing?.textAttributes()
            let attrTitle = NSAttributedString(string: stateTitle, attributes: attr)
            self.setAttributedTitle(attrTitle, for: state)
        }
        updateState()
    }
    
    override func onButtonClick(sender: UIButton) {
        isSelected = !isSelected
        onClick?(self)
    }
    
    
}
