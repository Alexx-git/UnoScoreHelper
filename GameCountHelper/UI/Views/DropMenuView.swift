//
//  DropMenuView.swift
//  Crypto
//
//  Created by Vlad on 4/16/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

protocol DropMenuItem: FontScalable, SkinStylable where Self: UIView {
}


class DropMenuView: BoxView, Skinnable {
    
    let itemsBoxView = BoxView()

    weak var owner: BaseViewController?

    override func setup() {
        super.setup()
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        itemsBoxView.insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        itemsBoxView.spacing = 4.0
        itemsBoxView.layer.cornerRadius = 8.0
        let tapRec = ClosureTapGestureRecognizer()
        tapRec.onTap = { [unowned self] _ in
            self.dismiss()
        }
        self.addGestureRecognizer(tapRec)
    }
    
    func setLayuot(_ layout: BoxLayout) {
        items = [itemsBoxView.boxed(layout: layout)]
        
    }

    func setItemViews(_ itemViews: [DropMenuItem]) {
        for view in itemViews {
            view.setFontScale(0.5)
            itemsBoxView.items.append(view.boxed)
        }
    }
    
    func setSkin(_ skin: Skin?) {
        if let brush = skin?.dropMenu {
            itemsBoxView.setBrush(brush)
        }
        var groups = SkinKeyGroups()
        groups.setOptional(skin?.barButton, forKey: .label)
        groups.setOptional(skin?.menuButton, forKey: .button)
        groups.setOptional(skin?.keyStyles, forKey: .fillButton)
        
        for item in itemsBoxView.items {
            if let diView = item.view as? DropMenuItem {
                diView.setSkinGroups(groups)
            }
        }
    }
    
    func dismiss(animated: Bool = true) {
        let dismissCompletion: ((Bool) -> Swift.Void) = { [weak self] _ in
            self?.removeFromSuperview()
            self?.owner?.dropMenuView = nil
            self?.owner = nil
        }
        if animated {
            let vaMenu = ViewAnimator(0.2)
            vaMenu.animation = { [weak self] in
                self?.alpha = 0.0
                let boxRect = self?.itemsBoxView.frame ?? .zero
                var rect = boxRect
                rect.origin.x += rect.width / 2.0
                rect.size *= 0.1
                self?.itemsBoxView.transform = CGAffineTransform(from: boxRect, toRect: rect )
            }
            vaMenu.completion = dismissCompletion
            vaMenu.run()
        }
        else {
            dismissCompletion(true)
        }
    }
}

extension BaseViewController {
    
    func showDropMenu( _ menuView: DropMenuView, from rect: CGRect, offset: CGPoint) {
        dropMenuView = menuView
        print("rect: \(rect)")
        menuView.owner = self
        let gap: CGFloat = 16.0
        let top = rect.maxY + offset.y
        view.addBoxItem(menuView.boxed)
        var layout = BoxLayout().withTop(==top).with(.bottom, >=gap)
        if (rect.midX > self.view.bounds.width * 0.5) {
            layout.left = >=gap; layout.right = >=gap
        }
        else {
            layout.left = >=gap; layout.right = >=gap
        }
        menuView.setLayuot(layout)
        
        let constr = NSLayoutConstraint(
            item: menuView.itemsBoxView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: menuView,
            attribute: .centerX,
            multiplier: rect.midX / self.view.bounds.midX,
            constant: 0.0)
        constr.priority = .defaultLow
        constr.isActive = true
        
        menuView.alpha = 0.0

        var startRect = rect
        startRect.origin.y += startRect.height * 0.7
        startRect.size.height *= 0.2
        
        let vaMenu = ViewAnimator(0.2, 0.05)
        vaMenu.before = {
            menuView.itemsBoxView.transform = CGAffineTransform(from: menuView.itemsBoxView.frame, toRect: startRect)
          }
        vaMenu.animation = {
            menuView.alpha = 1.0
            menuView.itemsBoxView.transform = .identity
        }
        vaMenu.completion = { _ in
//            print("menuView.managedConstraints: \(menuView.managedConstraints)")
//            print("itemsBoxView.managedConstraints: \(menuView.itemsBoxView.managedConstraints)")
        }
        vaMenu.run()
    }
}


