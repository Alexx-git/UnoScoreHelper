//
//  UIImage+Common.swift
//  GameCountHelper
//
//  Created by Vlad on 5/23/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init?(named name: String?) {
        if let name = name {
            self.init(named: name)
        }
        else {
            return nil
        }
    }
    
    class func template(_ template: String?) -> UIImage? {
        return UIImage.init(named: template ?? "")?.withRenderingMode(.alwaysTemplate)
    }

}
