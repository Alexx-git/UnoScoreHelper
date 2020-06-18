//
//  SkinLabel.swift
//  Crypto
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit


class SkinLabel: UILabel, DropMenuItem {
    var skinKey: SkinKey = .label
    
    var fontScale: CGFloat = 1.0
    var attributes: [NSAttributedString.Key: Any]?
    var skinGroup: SkinGroup?
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        skinGroup = groups[skinKey]
        if let style = skinGroup?[state.rawValue] {
            setSkinStyle(style)
        }
    }
    
    func setFontScale(_ fontScale: CGFloat) {
        self.fontScale = fontScale
    }
    
    
    func setSkinStyle(_ style: Skin.Style?) {
        if var style = style {
            style.scaleFontBy(fontScale)
            attributes = style.textDrawing?.textAttributes()
            attributes![.paragraphStyle] = NSParagraphStyle.withAlignment(self.textAlignment)
            let existingText = attributedText?.string ?? text ?? ""
            setBrush(style.box)
            self.text = existingText
        }
    }
    
    var state: Skin.State = .normal {
        didSet {
            if let style = skinGroup?[state.rawValue] {
                setSkinStyle(style)
            }
        }
    }
    
    override public var text: String? {
        didSet {
            if let text = text {
                self.attributedText = NSAttributedString(string: text, attributes: attributes)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            switch state {
                case .selected: state = (isHighlighted) ? .hlSelected : .selected
                case .hlSelected: state = (isHighlighted) ? .hlSelected : .selected
                case .disabled: ()
                default: state = (isHighlighted) ? .hl : .normal
            }
        }
    }

}

