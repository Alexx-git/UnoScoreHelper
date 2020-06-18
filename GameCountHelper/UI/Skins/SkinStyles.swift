//
//  SkinStyles.swift
//  Crypto
//
//  Created by Vlad on 4/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation
import UIKit



typealias SkinGroup = [String: Skin.Style]

extension Skin {
    
    enum State: String, Decodable {
        case normal, hl, selected, hlSelected, disabled
        
        var controlState: UIControl.State {
            switch self {
            case .hl: return .highlighted
            case .selected: return .selected
            case .hlSelected: return [.highlighted, .selected]
            case .disabled: return .disabled
            default: return []
            }
        }
        
        var substituteState: State {
            switch self {
            case .hl: return .normal
            case .selected: return .normal
            case .hlSelected: return .hl
            case .disabled: return .normal
            default: return .normal
            }
        }
        
        func groupWithStyle(_ style: Skin.Style) -> SkinGroup {
            return [self.rawValue: style]
        }
    }
    
    
    struct Style: Decodable {
        var box: Brush?
        var textDrawing: Text?
        
        static let empty = Style(box: .empty, textDrawing: .empty)
        
        mutating func adjustFontSizeToFitText(_ text:String, in rectSize:CGSize) {
            textDrawing?.adjustFontSizeToFitText(text, in: rectSize)
        }
        
        mutating func scaleFontBy(_ multiplier: CGFloat) {
            textDrawing?.scaleFontBy(multiplier)
        }
        
        func attributedString(_ text: String) -> NSAttributedString {
            let attributes = self.textDrawing?.textAttributes()
            return NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    typealias StateAndStyle = (Skin.State, Skin.Style)
}

extension SkinGroup {
    func styleForState(_ state: Skin.State) -> Skin.Style? {
        return self[state.rawValue]
    }
    
    func styleOrDefaultForState(_ state: Skin.State) -> Skin.Style? {
        return self[state.rawValue] ?? self[state.substituteState.rawValue]
    }
    
    mutating func adjustFontSizeToFitText(_ text:String, in rectSize:CGSize) {
        for state in self.keys {
            self[state]?.adjustFontSizeToFitText(text, in: rectSize)
        }
    }
    
    
    mutating func scaleFontBy(_ fontScale: CGFloat) {
        for state in self.keys {
            self[state]?.scaleFontBy(fontScale)
        }
    }

}

extension UIControl.State {
    var skinState: Skin.State {
        switch self {
        case .highlighted: return .hl
        case [.highlighted, .selected]: return .hlSelected
        case .selected: return .selected
        case .disabled: return .disabled
        default: return .normal
        }
    }
}

//    struct StyleGroup: Decodable {
//
////        var normal: Style?
////        var hl: Style?
//        var styles
//        static let empty = Button(normal: .empty, hl: .empty)
//
//        mutating func adjustFontSizeToFitText(_ text:String, in rectSize:CGSize) {
//            normal?.adjustFontSizeToFitText(text, in: rectSize)
//            hl?.adjustFontSizeToFitText(text, in: rectSize)
//        }
//
//        mutating func scaleFontBy(_ multiplier: CGFloat) {
//            normal?.scaleFontBy(multiplier)
//            hl?.scaleFontBy(multiplier)
//        }
//    }


struct LetterStyles: Decodable {
    var group: SkinGroup = [:]
//    var cryptable: Skin.Button
//    var nonCryptable: Skin.Style
    var boxAdjust: Skin.BoxAdjust?
//
//    static let empty = LetterStyles(encrypted: .empty, cryptable: .empty, nonCryptable: .empty)

//    mutating func adjustFontSizeToFitText(_ text:String, in rectSize:CGSize) {
////        encrypted.adjustFontSizeToFitText(text, in: rectSize)
////        cryptable.adjustFontSizeToFitText(text, in: rectSize)
////        nonCryptable.adjustFontSizeToFitText(text, in: rectSize)
//    }
}

    


