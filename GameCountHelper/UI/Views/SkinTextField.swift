//
//  SkinTextField.swift
//  GameCountHelper
//
//  Created by Vlad on 5/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class  SkinTextField: UITextField {
    var skinKey: SkinKey = .textField
    var fontScale: CGFloat = 1.0
    var attributes: [NSAttributedString.Key: Any]?

    func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        guard let group = groups[skinKey] else { return }
        if let style = group[Skin.State.normal.rawValue] {
            setSkinStyle(style)
        }
    }
    
    func setFontScale(_ fontScale: CGFloat) {
        self.fontScale = fontScale
    }
    

    func setSkinStyle(_ style: Skin.Style?) {
        if var style = style {
            style.scaleFontBy(fontScale)
            if var attributes = style.textDrawing?.textAttributes() {
                attributes[.paragraphStyle] = NSParagraphStyle.withAlignment(self.textAlignment)
                self.typingAttributes = attributes
                self.defaultTextAttributes = attributes
                setBrush(style.box)
            }
        }
    }

//    override public var text: String? {
//        didSet {
//            if let text = text {
//                self.attributedText = NSAttributedString(string: text, attributes: attributes)
//            }
//        }
//    }
}
