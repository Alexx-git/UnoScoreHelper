//
//  UIExtensions.swift
//  Crypto
//
//  Created by Vlad on 2/19/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import UIKit

extension Comparable {
    func clamped(_ limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension UIFont {
    class func with(name:String?, size:CGFloat?) -> UIFont {
        if let font = UIFont(name: name ?? "", size: size ?? 16) {
            return font
        }
        else {
            return systemFont(ofSize: size ?? 16)
        }
    }
    
    func rectSizeForText(_ text:NSString, fontSize:CGFloat)  -> CGSize {
        return text.size(withAttributes: [NSAttributedString.Key.font: self.withSize(fontSize)])
    }
    
    func maxFontSizeForText(_ text:NSString, in rectSize:CGSize) -> CGFloat {
        var fontSize:CGFloat = 17.0
        var textSize = self.rectSizeForText(text, fontSize: fontSize)
        if textSize.width < 1.0 || textSize.height < 1.0 {
            return 0.0
        }
        let scale = min(rectSize.width / textSize.width, rectSize.height / textSize.height)
        fontSize = floor((fontSize * scale)  * 2.0) / 2.0;
        textSize = self.rectSizeForText(text, fontSize: fontSize)
        while textSize.width >= rectSize.width || textSize.height >= rectSize.height {
            fontSize -= 0.5
            textSize = self.rectSizeForText(text, fontSize: fontSize)
        }
        return fontSize
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha:CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int, alpha:CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
    
    class func rgb(_ value: Int?, alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(rgb: value ?? 0, alpha: alpha)
    }
    
    public convenience init(hexString: String?) {
        let r, g, b, a: CGFloat
        let str = hexString ?? "00000000"
        if str.count == 8 {
            let scanner = Scanner(string: str)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        else if str.count == 6 {
            let scanner = Scanner(string: str)
            var hexNumber: UInt64 = 0
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x000000ff) / 255
                self.init(red: r, green: g, blue: b, alpha: 1.0)
                return
            }
        }
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }

    
    func lighter(offset: CGFloat) -> UIColor {
        guard let components = self.cgColor.components else { return self }
        let range = CGFloat(0.0)...CGFloat(1.0)
        return UIColor.init(red: (components[0] + offset).clamped(range), green: (components[1] + offset).clamped(range), blue: (components[2] + offset).clamped(range), alpha: components[3])
    }
    
}

extension NSShadow {
    class func rd(color: UIColor = UIColor.black, radius: CGFloat = 3.0, offset: CGFloat = 2.0 ) -> NSShadow {
        let sh = NSShadow()
        sh.shadowColor = color
        sh.shadowBlurRadius = radius
        sh.shadowOffset = CGSize(width: offset, height: offset)
        return sh
    }
}
