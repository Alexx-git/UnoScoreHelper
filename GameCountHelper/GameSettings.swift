//
//  GameSettings.swift
//  Crypto
//
//  Created by VLADIMIR on 2/14/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import Foundation

class GameSettings: NSObject, Codable {
    
    var showTimer = true
    
    var skinName: String?
    
    var inPlaceEditing = false
    
    let digitLimit = 5
    
    override init() {
        super.init()
    }

}
