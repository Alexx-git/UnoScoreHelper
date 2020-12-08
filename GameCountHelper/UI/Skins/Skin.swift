//
//  Skin.swift
//  Crypto
//
//  Created by Vlad on 4/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation
import UIKit

protocol Resolvable {
    func resolveBy(_ resolver: Skin.Resolver);
}

class Skin: Decodable {
    enum ImageKey: String {
        case main, bg
    }

    class Resolver {
        static let key = CodingUserInfoKey(rawValue: "resolver")!
        var namedColors = [String: String]()
        var namedFonts = [String: String]()
        
        func colorFrom(_ colorStr: String?) -> UIColor {
            return UIColor(hexString: namedColors[colorStr] ?? colorStr)
        }
        
        func fontNameFrom(_ fontStr: String?) -> String? {
            return namedFonts[fontStr] ?? fontStr
        }
    }
    
    
    
    var name: String?
    private var imageNames: [String: String] = [:]
    var bgColor: UIColor = .clear
    var dimColor: UIColor = .clear
    
    var divider: Skin.Brush = .empty
    var bigTitle: Skin.Style = .empty
    var h1: Skin.Style = .empty
    var h2: Skin.Style = .empty
    var avatar: Skin.Style = .empty
    
    var text: Skin.Style = .empty
    var editableNumbers: SkinGroup = [:]
//    var menuButton: SkinGroup = [:]
    var barButton: SkinGroup = [:]
    var barTitle: Skin.Style = .empty
//    var letterStyles: LetterStyles = LetterStyles()
    var keyStyles: SkinGroup = [:]
    var dropMenu: Skin.Brush = .empty
    var dropMenuItem: SkinGroup = [:]
    var cell: Skin.Brush = .empty
    
    
    
    func imageForKey(_ key: ImageKey) -> UIImage? {
        return UIImage(named: imageNames[key.rawValue])
    }
    
    enum CodingKeys: String, CodingKey {
        case name, imageNames, namedColors, namedFonts, bgColor, dimColor, dropMenu, dropMenuItem, text, bigTitle, h1, h2, avatar, barButton, barTitle, divider, letterStyles, keyStyles, editableNumbers, cell
    }
    
    
    required init(from decoder: Decoder) throws {
//        let resolver = Resolver(container: try decoder.container(keyedBy: CodingKeys.self))
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resolver = decoder.resolver!
        container.setIfDecoded(&name, key: .name)
        container.setIfDecoded(&resolver.namedColors, key: .namedColors)
        container.setIfDecoded(&resolver.namedFonts, key: .namedFonts)
        bgColor = resolver.colorFrom(container.decodedForKey(.bgColor))
        dimColor = resolver.colorFrom(container.decodedForKey(.dimColor))
        container.setIfDecoded(&imageNames, key: .imageNames)
        container.setIfDecoded(&text, key: .text)
        container.setIfDecoded(&bigTitle, key: .bigTitle)
        container.setIfDecoded(&h1, key: .h1)
        container.setIfDecoded(&h2, key: .h2)
        container.setIfDecoded(&avatar, key: .avatar)
        container.setIfDecoded(&editableNumbers, key: .editableNumbers)
        container.setIfDecoded(&dropMenu, key: .dropMenu)
        container.setIfDecoded(&dropMenuItem, key: .dropMenuItem)
//        container.setIfDecoded(&menuButton, key: .menuButton)
        container.setIfDecoded(&self.barButton, key: .barButton)
        container.setIfDecoded(&self.barTitle, key: .barTitle)
        container.setIfDecoded(&self.divider, key: .divider)
        container.setIfDecoded(&self.keyStyles, key: .keyStyles)
        container.setIfDecoded(&cell, key: .cell)
    }
    
    init() {
    }
    
}

extension Decoder {
    var resolver: Skin.Resolver? {
        userInfo[Skin.Resolver.key] as? Skin.Resolver
    }
}

