//
//  SkinProperties.swift
//  Crypto
//
//  Created by Vlad on 4/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation
import UIKit
extension Skin {
    
    struct Shadow: Decodable
    {
        private var colorStr: String
        var color: UIColor {
            return UIColor(hexString: colorStr)
        }
        var radius: CGFloat
        var offset: CGSize
        
        enum CodingKeys: String, CodingKey {
            case colorStr = "color", radius, offset
        }

        static let zero: Shadow = Shadow(colorStr: "000000", radius: 0.0, offset: .zero)
        
        func nsShadow() -> NSShadow {
            let sh = NSShadow()
            sh.shadowColor = color
            sh.shadowBlurRadius = radius
            sh.shadowOffset = offset
            return sh
        }
    }
    
    struct Font: Decodable {
        var size: CGFloat = 16.0
        var name: String? = nil

        static let standard = Font(size: 16.0, name: nil)
        
        func uiFont() -> UIFont {
            if let name = name {
                return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
            }
            else {
                return UIFont.systemFont(ofSize: size)
            }
        }
    }
        
    struct Brush: Decodable {
        var stroke: UIColor
        var fill: UIColor
        var strokeWidth: CGFloat
        var shadow: Skin.Shadow?
        
        static let empty = Brush()
        
        enum CodingKeys: String, CodingKey {
            case stroke, fill, strokeWidth, shadow
        }
        
        init(){
            fill = .clear
            stroke = .clear
            strokeWidth = 0.0
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            let strokeColorStr = try container.decodeIfPresent(String.self, forKey: .stroke)
            self.stroke =  UIColor(hexString: strokeColorStr)
            let fillColorStr = try container.decodeIfPresent(String.self, forKey: .fill)
            self.fill = UIColor(hexString: fillColorStr)
            self.strokeWidth = try container.decodeIfPresent(CGFloat.self, forKey: .strokeWidth) ?? 0.0
            self.shadow = try container.decodeIfPresent(Skin.Shadow.self, forKey: .shadow)
        }
    }
    
    
    struct Text: Decodable {
        
        struct Effects: Codable
        {
            var offset: CGPoint = .zero
            var contrast: CGFloat = 0.5
            var isEmbossTwoSided = true
            var shadowWidth: CGFloat = 0
            var borderWidth: CGFloat = 0
            var borderColorValue: Int = 0
            var engraveWidth: CGFloat = 0
            func borderColor() -> UIColor {
                return UIColor.rgb(borderColorValue)
            }

        }
//
        var effects: Effects?
        var font: UIFont
        var brush: Skin.Brush
        
        var paragraphStyle: NSParagraphStyle
        
        enum CodingKeys: String, CodingKey {
            case brush, effects, font
        }
        
        static let empty = Text()
        
        init() {
            self.brush = Skin.Brush()
            self.font = UIFont.systemFont(ofSize: 16)
            self.effects = Effects()
            self.paragraphStyle = NSParagraphStyle()
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.brush = try container.decodeIfPresent(Skin.Brush.self, forKey: .brush) ?? Skin.Brush()
            self.effects = try container.decodeIfPresent(Effects.self, forKey: .effects) ?? Effects()
            let drawingFont = try container.decodeIfPresent(Skin.Font.self, forKey: .font) ?? .standard
            self.font = drawingFont.uiFont()
            var ps = NSMutableParagraphStyle()
//            ps.lineBreakMode = .byTruncatingTail
            self.paragraphStyle = ps
//            style.alignment = .center
        }
        
        func textAttributes() -> Dictionary<NSAttributedString.Key,Any> {
            var dict: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.strokeWidth: brush.strokeWidth,
                NSAttributedString.Key.strokeColor: brush.stroke,
                NSAttributedString.Key.foregroundColor: brush.fill
            ]
            if let shadow = brush.shadow {
                dict[NSAttributedString.Key.shadow] = shadow.nsShadow()
            }
    //            NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            return dict
        }
        
        mutating func adjustFontSizeToFitText(_ text:String, in rectSize:CGSize) {
            let fontSize = self.font.maxFontSizeForText(text as NSString, in: rectSize)
            self.font = self.font.withSize(fontSize)
        }

        mutating func scaleFontBy(_ multiplier: CGFloat) {
            let fontSize = self.font.pointSize * multiplier
            self.font = self.font.withSize(fontSize)
        }
        
        func draw(text: String, context: CGContext, rect: CGRect, offset: CGPoint = .zero)
        {
            let str = text as NSString
            var drawRect = rect + offset
//            guard let attr = attributes else { str.draw(in: drawRect); return}
            let shOffset = brush.shadow?.offset ?? .zero
            var attrDict = textAttributes()
            guard let eff = effects else { str.draw(in: drawRect, withAttributes: attrDict); return}
            
            if eff.offset != .zero && eff.contrast != 0.0 {
                let dx = abs(eff.offset.x)
                let dy = abs(eff.offset.y)
                let insets = UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx)
                drawRect = (rect + offset).inset(by: insets)
                attrDict[NSAttributedString.Key.foregroundColor] = brush.fill.lighter(offset: eff.contrast)
                str.draw(in: drawRect + eff.offset, withAttributes: attrDict)
                
                attrDict[NSAttributedString.Key.foregroundColor] = brush.fill.lighter(offset: -eff.contrast)
                str.draw(in: drawRect - eff.offset, withAttributes: attrDict)
                
                attrDict[NSAttributedString.Key.foregroundColor] = brush.fill
                str.draw(in: drawRect, withAttributes: attrDict)
            }
            else{
                str.draw(in: rect, withAttributes: attrDict)
            }

        }
    }
    
    struct BoxAdjust: Decodable {
        var offset: CGPoint
        var expand: CGSize
    }

    
}
