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


class DropMenuView: BaseView, Skinnable {
    let boxView = BoxView()
    var boxConstraints: LayoutAttributeConstraints = [:]
    var heightConstraint: NSLayoutConstraint?
    weak var owner: BaseViewController?

    override func setupSubviews() {
        super.setupSubviews()
        addSubview(boxView)
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        boxView.insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        boxView.spacing = 4.0
        layer.cornerRadius = 5.0
        let tapRec = ClosureTapGestureRecognizer()
        tapRec.onTap = { [unowned self] _ in
            self.dismiss()
        }
        self.addGestureRecognizer(tapRec)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
//        backView.alToSuperviewWithEdgeValues(.zero)
//        boxConstraints = boxView.alToSuperviewWithEdgeValues(.zero)
    }
    
    func setItemViews(_ itemViews: [DropMenuItem]) {
        var items = [BoxItem]()
        for view in itemViews {
            view.setFontScale(0.5)
            items.append(view.boxZero)
        }
        boxView.items = items
    }
    
    func setSkin(_ skin: Skin?) {
        if let brush = skin?.dropMenu {
            boxView.setBrush(brush)
        }
        var groups = SkinKeyGroups()
        groups.setOptional(skin?.barButton, forKey: .label)
        groups.setOptional(skin?.menuButton, forKey: .button)
        groups.setOptional(skin?.keyStyles, forKey: .fillButton)
        
        for item in boxView.items {
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
                let boxRect = self?.boxView.frame ?? .zero
                var rect = boxRect
                rect.origin.x += rect.width / 2.0
                rect.size *= 0.1
                self?.boxView.transform = CGAffineTransform(from: boxRect, toRect: rect )
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
        menuView.owner = self
        view.addSubview(menuView)
        let gap: CGFloat = 16.0
        let top = rect.maxY + offset.y
        menuView.alToSuperviewWithEdgeValues(.zero)
        menuView.boxView.autoPinEdge(toSuperviewEdge: .top, withInset: top)
        if (rect.midX > self.view.bounds.width * 0.5) {
            menuView.boxView.autoPinEdge(toSuperviewEdge: .right, withInset: gap)
            menuView.boxView.autoPinEdge(toSuperviewEdge: .left, withInset: gap, relation: .greaterThanOrEqual)
        }
        else {
            menuView.boxView.autoPinEdge(toSuperviewEdge: .right, withInset: gap, relation: .greaterThanOrEqual)
            menuView.boxView.autoPinEdge(toSuperviewEdge: .left, withInset: gap)
        }
        menuView.alpha = 0.0

        let vaMenu = ViewAnimator(0.2, 0.05)
        vaMenu.before = {
            menuView.boxView.transform = CGAffineTransform(from: menuView.boxView.frame, toRect: rect)
          }
        vaMenu.animation = {
            menuView.alpha = 1.0
            menuView.boxView.transform = .identity
        }
        vaMenu.run()
    }
}


