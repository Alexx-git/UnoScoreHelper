//
//  Numbers+Common.swift
//  Crypto
//
//  Created by Vlad on 4/22/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import Foundation
import UIKit

//extension Comparable {
//    func clamped(to limits: ClosedRange<Self>) -> Self {
//        return min(max(self, limits.lowerBound), limits.upperBound)
//    }
//}
//
//extension Strideable where Stride: SignedInteger {
//    func clamp(_ limits: CountableClosedRange<Self>) -> Self {
//        return min(max(self, limits.lowerBound), limits.upperBound)
//    }
//}


extension Comparable {
    func clamp(_ min: Self?, _ max: Self?) -> Self {
        if let min = min {
            if self < min {
                return min
            }
        }
        if let max = max {
            if self > max {
                return max
            }
        }
        return self
    }
}

extension Int {
    func toStr(_ format: String = "") -> String {
        return String(format: "%\(format)d", self)
    }
}

extension Double {
    func toStr(_ format: String = ".2") -> String {
        return String(format: "%\(format)f", self)
    }
}

extension Double {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension Int {
    var f: CGFloat {
        return CGFloat(self)
    }
}
