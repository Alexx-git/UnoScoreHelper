//
//  GenericRowView.swift
//  GameCountHelper
//
//  Created by Vlad on 6/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class GenericRowView<Element: UIView>: BoxView {

    typealias ElementTapHandler = (GenericRowView, Element) -> Void
    
    typealias ElementHandler = (Element) -> Void
    
    typealias ValueHandler = (Element, Any) -> Void
        
    let numberLabel = SkinLabel()
    
    var elements = [Element]()
    var dividers = [UIView]()
    var skinGroups = [SkinKey: SkinGroup]()
        
    var tapHandler: ElementTapHandler?
    
    var onInit: ElementHandler?
    
    var closureSetupElement: ElementHandler?
    
    var closureSetValue: ValueHandler?
    
    var closureSetSkin: ValueHandler?
    
    var divWidth: CGFloat = 1.0
    
    var numberWidth: CGFloat {
        get {
            return numberWidthConstraint?.constant ?? 0
        }
        set {
            numberWidthConstraint?.isActive = true
            numberWidthConstraint?.constant = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    var numberWidthConstraint: NSLayoutConstraint?
    
    convenience init() {
        self.init(axis: .x)
        numberWidthConstraint = numberLabel.bxPinWidth(10.0)
        let tapRec = ClosureTapGestureRecognizer()
        tapRec.onTap = { [unowned self] rec in
//            self.dismiss()
            let point = rec.location(in: self)
            for element in self.elements {
                if element.frame.contains(point) {
                    self.tapHandler?(self, element)
                    break
                }
            }
        }
        self.addGestureRecognizer(tapRec)
    }

        
    func setRow(values: [Any]) {
        
        if items.count != values.count {
            createElements(count: values.count)
        }
        for (index, value) in values.enumerated() {
            closureSetValue?(elements[index], value)
        }
    }
    
    private func createElements(count: Int) {
        
        self.items = [numberLabel.boxed]
        elements = []
        var prevEl: Element? = nil
        for _ in 0..<count {
            let divView = UIView()
            self.items.append(divView.boxed.width(divWidth).top(-insets.top).bottom(-insets.bottom))
            dividers.append(divView)
            let element = Element()
            elements.append(element)
            element.setContentHuggingPriority(.defaultHigh, for: .vertical)
            onInit?(element)
            self.items.append(element.boxed)
            prevEl?.bxPinWidth(0.0, to: element)
            prevEl = element
            
        }
        updateSkin()
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        skinGroups = groups
        updateSkin()
    }
    
    func updateSkin() {
        if let group = skinGroups[SkinKey.label] {
            numberLabel.setSkinStyle(group.styleForState(.normal))
            if let group = skinGroups[SkinKey.divider] {
                for div in self.dividers {
                    div.setBrush(group.styleForState(.normal)?.box)
                }
            }
            guard Element.self is Skinnable.Type else {return}
            for element in self.elements {
                closureSetSkin?(element, skinGroups)
            }

        }
        
    }
    
    func elementWidth() -> CGFloat {
        let count = CGFloat(elements.count)
        return (self.bounds.width - insets.left - insets.right - numberWidth - 2 * count * spacing - count * divWidth) / CGFloat(elements.count)
    }

}
