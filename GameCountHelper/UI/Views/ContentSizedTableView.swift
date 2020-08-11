//
//  ContentSizedTableView.swift
//  GameCountHelper
//
//  Created by Vlad on 5/31/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

final class ContentSizedTableView: UITableView {
    
    typealias SizeUpdateHandler = (CGSize, CGSize) -> Void
    
    var onSizeUpdate: SizeUpdateHandler?
    
    override var contentSize:CGSize {
        didSet {
            onSizeUpdate?(contentSize, oldValue)
        }
    }

//    override var intrinsicContentSize: CGSize {
//
//        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//    }
}
