//
//  ElementRowView.swift
//  GameCountHelper
//
//  Created by Vlad on 7/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

protocol RowElement: UIView {
    var label: SkinLabel? { get }
//    func setValue(value: Any)
}

extension SkinLabel: RowElement {
    var label: SkinLabel? {
        return self
    }
}

 class ElementRowView: BoxView {

    typealias LabelTapHandler = (ElementRowView, RowElement) -> Void
        
    let numberLabel = SkinLabel()
    
    var elements = [RowElement]()
    var dividers = [UIView]()
    var skinGroups = [SkinKey: SkinGroup]()
        
    var tapHandler: LabelTapHandler?
    
    var minAllowedFontSize: CGFloat = 16.0
    
    var maxAllowedFontSize: CGFloat = 42.0
    
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

        
    func setRow(texts: [String]) {
        
        if elements.count != texts.count {
            createElements(count: texts.count)
        }
        for (index, element) in elements.enumerated() {
            element.label?.text = texts[index]
        }
    }
    
    func createElements(count: Int) {
        
        self.items = [numberLabel.boxed]
        elements = []
        var prevEl: RowElement? = nil
        for _ in 0..<count {
            let divView = UIView()
            divView.backgroundColor = .red
            self.items.append(divView.boxed.width(divWidth).top(-insets.top).bottom(-insets.bottom))
            dividers.append(divView)
            let element = newElement()
            elements.append(element)
            
            element.setContentHuggingPriority(.defaultHigh, for: .vertical)
            self.items.append(element.boxed)
            prevEl?.bxPinWidth(0.0, to: element)
            prevEl = element
            
        }
        updateSkin()
    }
    
    func newElement() -> RowElement {
        let label = SkinLabel()
        label.textAlignment = .center
        return label
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup]) {
        skinGroups = groups
        updateSkin()
    }
    
    func updateSkin() {
        if let group = skinGroups[SkinKey.label] {
            numberLabel.setSkinStyle(group.styleForState(.normal))
            let groups = [SkinKey.label: group]
            for element in self.elements {
                element.label?.setSkinGroups(groups)
                element.label?.lineBreakMode = .byTruncatingTail
            }

        }
        if let group = skinGroups[SkinKey.divider] {
            for div in self.dividers {
                div.setBrush(group.styleForState(.normal)?.box)
            }
        }
    }
    
    func adjustFont() {
        var minSize = maxAllowedFontSize
        
        let width = labelWidth()
        let size = CGSize(width: width, height: 40.0)
        guard let font = elements.first?.label?.font else {return}
        for element in elements {
            guard let text = element.label?.text as? NSString else {continue}
            minSize = min(minSize, font.maxFontSizeForText(text, in: size))
        }
        let minFont = font.withSize(max(minSize, minAllowedFontSize))
        setFont(font: minFont)
    }
    
    func labelWidth() -> CGFloat {
        let count = CGFloat(elements.count)
        return (self.bounds.width - insets.left - insets.right - numberWidth - 2 * count * spacing - count * divWidth) / CGFloat(elements.count)
    }
    
    func setFont(font: UIFont) {
        elements.forEach{$0.label?.font = font}
    }
    
    func elementWidth() -> CGFloat {
        let count = CGFloat(elements.count)
        return (self.bounds.width - insets.left - insets.right - numberWidth - 2 * count * spacing - count * divWidth) / CGFloat(elements.count)
    }
}
