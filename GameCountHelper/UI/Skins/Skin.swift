//
//  Skin.swift
//  Crypto
//
//  Created by Vlad on 4/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation
import UIKit

class Skin: Decodable {
    enum ImageKey: String {
        case main
    }
    var name: String?
    private var imageNames: [String: String] = [:]
    var bgColor: UIColor = .clear
    var divider: Skin.Brush = .empty
    var titlesText: Skin.Style = .empty
    var h1: Skin.Style = .empty
    var h2: Skin.Style = .empty
    var avatar: Skin.Style = .empty
    
    var text: Skin.Style = .empty
    var editableNumbers: SkinGroup = [:]
    var menuButton: SkinGroup = [:]
    var barButton: SkinGroup = [:]
    var barTitle: Skin.Style = .empty
    var letterStyles: LetterStyles = LetterStyles()
    var keyStyles: SkinGroup = [:]
    var dropMenu: Skin.Brush = .empty
    var dropMenuItem: SkinGroup = [:]
    
    func imageForKey(_ key: ImageKey) -> UIImage? {
        return UIImage(named: imageNames[key.rawValue])
    }
    
    enum CodingKeys: String, CodingKey {
        case name, imageNames, bgColor, dropMenu, dropMenuItem, titlesText, text, h1, h2, avatar, menuButton, barButton, barTitle, divider, letterStyles, keyStyles, editableNumbers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "untitled"
        imageNames = try container.decodeIfPresent([String: String].self, forKey: .imageNames) ?? [:]
        bgColor = UIColor(hexString: try container.decodeIfPresent(String.self, forKey: .bgColor))
        container.setIfDecoded(&titlesText, key: .titlesText)
        container.setIfDecoded(&text, key: .text)
        container.setIfDecoded(&h1, key: .h1)
        container.setIfDecoded(&h2, key: .h2)
        container.setIfDecoded(&avatar, key: .avatar)
        container.setIfDecoded(&editableNumbers, key: .editableNumbers)

        container.setIfDecoded(&dropMenu, key: .dropMenu)
        container.setIfDecoded(&dropMenuItem, key: .dropMenuItem)
        container.setIfDecoded(&menuButton, key: .menuButton)
        container.setIfDecoded(&self.barButton, key: .barButton)
        container.setIfDecoded(&self.barTitle, key: .barTitle)
        container.setIfDecoded(&self.divider, key: .divider)
        container.setIfDecoded(&self.letterStyles, key: .letterStyles)
        container.setIfDecoded(&self.keyStyles, key: .keyStyles)
        
    }
    
    init() {
    }
    
}

