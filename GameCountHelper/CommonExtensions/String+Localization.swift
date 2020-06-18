//
//  String+Localization.swift
//  Crypto
//
//  Created by Vlad on 4/18/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation

extension String {
    var ls: String {
        return NSLocalizedString(self, comment: "")
    }
}
