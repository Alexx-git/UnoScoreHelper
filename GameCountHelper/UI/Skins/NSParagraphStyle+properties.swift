//
//  NSParagraphStyle+properties.swift
//  GameCountHelper
//
//  Created by Vlad on 5/31/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension NSParagraphStyle {
    
    class func withAlignment(_ alignment: NSTextAlignment) -> NSParagraphStyle {
        let ps = NSMutableParagraphStyle()
        ps.alignment = alignment
        return ps.copy() as! NSParagraphStyle
    }
    
}
