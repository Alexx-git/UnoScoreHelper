//
//  GameSettings.swift
//  Crypto
//
//  Created by VLADIMIR on 2/14/19.
//  Copyright © 2019 ALEXANDER. All rights reserved.
//

import Foundation



//enum KeyboardType: String {
//    case abc, qwerty
//}

class GameSettings: NSObject, Codable {
    
    
    
    var showTimer = true
    
    var skinName: String?
    
    override init() {
        super.init()
    }

}
