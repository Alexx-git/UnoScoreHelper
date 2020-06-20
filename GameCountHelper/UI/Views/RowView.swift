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
    
    var numberWidthConstraint: NSLayoutConstraint?
        
    var tapHandler: LabelTapHandler?
    
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
    
    var labels = [SkinLabel]()
    var skinGroup: SkinGroup?
    
    convenience init() {
        self.init(axis: .x)
        numberWidthConstraint = numberLabel.alPinWidth(10.0)
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
        
        self.items = [numberLabel.boxZero]
        labels = []
        var prevLabel: UILabel? = nil
        for _ in 0..<count {
            let label = SkinLabel()
            labels.append(label)
            label.textAlignment = .center
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            self.items.append(label.boxZero)
            prevLabel?.alPinWidth(0.0, to: label)
            prevLabel = label
        }
        updateSkin()
    }
    
    func setSkinGroups(_ groups: [SkinKey: SkinGroup])
    {
        skinGroup = groups[.label]
        updateSkin()
    }
    
    func updateSkin()
    {
        numberLabel.setSkinStyle(skinGroup?.styleForState(.normal))
        if let group = skinGroup {
            let groups = [SkinKey.label: group]
            for label in self.labels {
                label.setSkinGroups(groups)
            }
        }
    }
    
}
