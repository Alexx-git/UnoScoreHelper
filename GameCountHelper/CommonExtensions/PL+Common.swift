//
//  PL+Common.swift
//  Crypto
//
//  Created by Vlad on 3/28/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

//
//  Corrigo+PureLayout.swift
//  CustomerPortal
//
//  Created by Vlad on 10/4/18.
//  Copyright © 2018 Corrigo Inc. All rights reserved.
//

import UIKit
import PureLayout

typealias ALEdgeValues = [ALEdge: CGFloat]
typealias ALEdgeConstraints = [ALEdge: NSLayoutConstraint]

//extension UIView {
//    
//    @discardableResult
//    func alToSuperviewWithEdgeValues(_ dict: ALEdgeValues) -> ALEdgeConstraints {
//        var constraints = ALEdgeConstraints()
//        for (key, value) in dict {
//            constraints[key] = self.autoPinEdge(toSuperviewEdge: key, withInset: value)
//        }
//        return constraints
//    }
//}

extension ALEdgeValues {
    
    static let zero = all(0.0)
    
    static func all(_ value: CGFloat = 0.0, excluding edge: ALEdge? = nil) -> ALEdgeValues {
        var dict: ALEdgeValues = [.top: value, .bottom: value, .leading:value, .trailing:value]
        if let edge = edge {
            dict[edge] = nil
        }
        return dict
    }
}

extension ALEdge {

    static func all(_ value: CGFloat = 0.0, excluding edge: ALEdge? = nil) -> ALEdgeValues {
        var dict: ALEdgeValues = [.top: value, .bottom: value, .leading:value, .trailing:value]
        if let edge = edge {
            dict[edge] = nil
        }
        return dict
    }

}

