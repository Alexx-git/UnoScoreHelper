//
//  Range+Common.swift
//  Crypto
//
//  Created by Vlad on 4/26/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    
    func ranges() -> [NSRange] {
        var ranges = [NSRange]()
        guard var start = self.first else {return [NSRange]()}
        var end = self.first!
        for int in self {
            guard int != start else {continue}
            if int == end + 1 {
                end = int
            } else {
                ranges.append(NSRange(location: start, length: end - start + 1))
                start = int
                end = int
            }
        }
        ranges.append(NSRange(location: start, length: end - start + 1))
        return ranges
    }
}
