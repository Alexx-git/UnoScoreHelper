//
//  RowView.swift
//  GameCountHelper
//
//  Created by Vlad on 5/20/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import PureLayout
import BoxView

class RowView: BoxView {
    
    typealias LabelTapHandler = (RowView, SkinLabel) -> Void
    
    let numberLabel = SkinLabel()
    
    var labels = [SkinLabel]()
    var dividers = [UIView]()
    var skinGroups = [SkinKey: SkinGroup]()
        
    var tapHandler: LabelTapHandler?
    
    var minAllowedFontSize: CGFloat = 16.0
    
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
            for label in self.labels {
                if label.frame.contains(point) {
                    self.tapHandler?(self, label)
//                    self.selectedLabel = label
//                    label.state = .selected
                    break
                }
            }

        }
        self.addGestureRecognizer(tapRec)
    }

        
    func setRow(values: [String]) {
        
        if items.count != values.count {
            createLabels(count: values.count)
        }
        for (index, value) in values.enumerated() {
            labels[index].text = value
        }
    }
    
    private func createLabels(count: Int) {
        
        self.items = [numberLabel.boxed]
        labels = []
        var prevLabel: UILabel? = nil
        for _ in 0..<count {
            let divView = UIView()
            divView.backgroundColor = .red
            self.items.append(divView.boxed.width(divWidth).top(-insets.top).bottom(-insets.bottom))
            dividers.append(divView)
            let label = SkinLabel()
            labels.append(label)
            label.textAlignment = .center
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            self.items.append(label.boxed)
            prevLabel?.bxPinWidth(0.0, to: label)
            prevLabel = label
            
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
            let groups = [SkinKey.label: group]
            for label in self.labels {
                label.setSkinGroups(groups)
                label.lineBreakMode = .byTruncatingTail
            }

        }
        if let group = skinGroups[SkinKey.divider] {
            for div in self.dividers {
                div.setBrush(group.styleForState(.normal)?.box)
            }
        }
    }
    
    func adjustFont() {
        var minSize: CGFloat = 40.0
        
        let width = labelWidth()
        let size = CGSize(width: width, height: 40.0)
        guard let font = labels.first?.font else {return}
        for label in labels {
            guard let text = label.text as? NSString else {continue}
            minSize = min(minSize, font.maxFontSizeForText(text, in: size))
        }
        let minFont = font.withSize(max(minSize, minAllowedFontSize))
        setFont(font: minFont)
    }
    
    func labelWidth() -> CGFloat {
        let count = CGFloat(labels.count)
        return (self.bounds.width - insets.left - insets.right - numberWidth - 2 * count * spacing - count * divWidth) / CGFloat(labels.count)
    }
    
    func setFont(font: UIFont) {
        labels.forEach{$0.font = font}
    }
    
}
