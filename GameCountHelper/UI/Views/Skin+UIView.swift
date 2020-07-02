//
//  SkinView.swift
//  Crypto
//
//  Created by Vlad on 4/12/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension UIView {
    
    func setBrush(_ brush: Skin.Brush?) {
        if let bgColor = brush?.fill {
            backgroundColor = bgColor
        }
        if let strokeColor = brush?.stroke {
            layer.borderColor = strokeColor.cgColor
            layer.borderWidth = brush?.strokeWidth ?? 0.0
        }
        if let shadow = brush?.shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowRadius = shadow.radius
            layer.shadowOffset = shadow.offset
            layer.shadowOpacity = 1.0
        }
        else {
            layer.shadowOpacity = 0.0
            layer.shadowRadius = 0.0
        }
    }
}

extension UIImageView {
    
    func setImageBrush(_ brush: Skin.Brush?) {
        if image != nil {
            self.tintColor = brush?.fill
            if let shadow = brush?.shadow {
                layer.shadowColor = shadow.color.cgColor
                layer.shadowRadius = shadow.radius
                layer.shadowOffset = shadow.offset
                layer.shadowOpacity = 1.0
            }
            else {
                layer.shadowOpacity = 0.0
                layer.shadowRadius = 0.0
            }
        }
    }
}
