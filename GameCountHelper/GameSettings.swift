//
//  GameSettings.swift
//  Crypto
//
//  Created by VLADIMIR on 2/14/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import Foundation

class GameSettings: NSObject, Codable {
    
    var showTimer = true {
        didSet {
            saveSettings()
        }
    }
    
    var skinNames: [UIStyle: String] = [
        .light: SkinManager.defaultLightSkinName,
        .dark: SkinManager.defaultDarkSkinName
    ] {
        didSet {
            saveSettings()
        }
    }
    
    var sameSkinForAllModes: Bool = false
    
    var skinName: String {
        return SkinManager.defaultSkinName
    }
    
    var inPlaceEditing = false {
        didSet {
            saveSettings()
        }
    }
    
    static let digitLimit = 5
    
    override init() {
        super.init()
    }
    
    func saveSettings() {
        GameManager.shared.storedSettings.value = self
    }

}
