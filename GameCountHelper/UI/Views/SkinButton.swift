//
//  SkinButton.swift
//  Crypto
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class SkinButton: StateUpdatingButton, DropMenuItem {
    var skinKey: SkinKey = .button
    var fontScale: CGFloat = 1.0
    var skinGroup: SkinGroup = [:]
    
    var title: String? {
        title(for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onStateChange = { [unowned self] _  in
            self.updateState()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFontScale(_ fontScale: CGFloat) {
        self.fontScale = fontScale
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        guard let group = groups[skinKey] else { return }
        skinGroup = group

//        for (state, style) in skinGroup {
//            let cState = Skin.State(rawValue:state)?.controlState ?? .normal
//            let stateTitle = attributedTitle(for: cState)?.string ?? title(for: cState) ?? ""
//            let attr = style.textDrawing?.textAttributes()
//            let attrTitle = NSAttributedString(string: stateTitle, attributes: attr)
//            self.setAttributedTitle(attrTitle, for: cState)
//        }
//        updateState()
        updateStateTitles()
    }
    
    func updateStateTitles() {
        for key in skinGroup.keys {
            skinGroup[key]?.scaleFontBy(fontScale)
        }
        for (state, style) in skinGroup {
            let cState = Skin.State(rawValue:state)?.controlState ?? .normal
            let stateTitle = attributedTitle(for: cState)?.string ?? title(for: cState) ?? ""
            let attr = style.textDrawing?.textAttributes()
            let attrTitle = NSAttributedString(string: stateTitle, attributes: attr)
            self.setAttributedTitle(attrTitle, for: cState)
        }
        updateState()
    }
    
    func updateState() {
        let style = skinGroup.styleForState(state.skinState)
        if let bgColor = style?.box?.fill {
            backgroundColor = bgColor
        }
        if let strokeColor = style?.box?.stroke {
            layer.borderColor = strokeColor.cgColor
            layer.borderWidth = style?.box?.strokeWidth ?? 0.0
        }
        if let shadow = style?.box?.shadow {
            layer.shadowColor = shadow.color.cgColor
            layer.shadowRadius = shadow.radius
            layer.shadowOffset = shadow.offset
            layer.shadowOpacity = 1.0
        }
        else {
            layer.shadowOpacity = 0.0
            layer.shadowRadius = 0.0
        }
        
//        let imgStyle = skinGroup.styleForState(.normal)

        if imageView?.image != nil {
            let brush = style?.textDrawing?.brush
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
    
    func setTitle(_ title: String?) {
        super.setTitle(title, for: .normal)
        for (state, style) in skinGroup {
            let cState = Skin.State(rawValue:state)?.controlState ?? .normal
            let attr = style.textDrawing?.textAttributes()
            let attrTitle = NSAttributedString(string: title ?? "", attributes: attr)
            self.setAttributedTitle(attrTitle, for: cState)
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        let skinState = state.skinState.rawValue
        let attr = skinGroup[skinState]?.textDrawing?.textAttributes()
        let attrTitle = NSAttributedString(string: title ?? "", attributes: attr)
        self.setAttributedTitle(attrTitle, for: state)
    }
    
    func setImage(_ image: UIImage?) {
        super.setImage(image, for: .normal)
        updateState()
    }
}
