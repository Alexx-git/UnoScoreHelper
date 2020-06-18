//
//  Skinnable.swift
//  Crypto
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

protocol Skinnable {
    func setSkin(_ skin: Skin?)
}

typealias SkinnableView = UIView & Skinnable

enum SkinKey: String {
    case button, label, fillButton, textField
    
    func groupsWithState(_ state: Skin.State, style: Skin.Style) -> [SkinKey: SkinGroup] {
        return [self: state.groupWithStyle(style)]
    }
    
    func groupsWithNormalStyle(_ style: Skin.Style) -> [SkinKey: SkinGroup] {
        return [self: Skin.State.normal.groupWithStyle(style)]
    }
    
}

typealias SkinKeyGroups = [SkinKey: SkinGroup]

protocol SkinStylable {
    func setSkinGroups(_ groups: SkinKeyGroups)
}

protocol FontScalable {
//    var fontScale: CGFloat {get set}
    func setFontScale(_ fontScale: CGFloat)
}


