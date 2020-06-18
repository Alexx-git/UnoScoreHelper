//
//  TopBarViewController.swift
//  Crypto
//
//  Created by Vlad on 4/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class TopBarViewController: BaseViewController {

    let contentBoxView = BoxView()

    let topBarView = TopBarView()

    override func setupViewContent() {
        super.setupViewContent()
        view.addSubview(topBarView)
        view.addSubview(contentBoxView)
        topBarView.backgroundColor = .clear
    }

    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        topBarView.alToSuperviewWithEdgeValues([.top: 16.0, .left: 0.0, .right: 0.0])
        contentBoxView.alToSuperviewWithEdgeValues(.all(0.0, excluding: .top))
        contentBoxView.autoPinEdge(.top, to: .bottom, of: topBarView, withOffset: 0.0)
    }
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        view.backgroundColor = skin.bgColor
        topBarView.setSkin(skin)
    }
    
    func setupBackButton() {
        topBarView.leftButton.setTitle("◄", for: .normal)
        topBarView.leftButton.onClick = { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showDropMenuItems( _ items: [DropMenuItem], sender: UIView) {
        dropMenuView = DropMenuView()
        dropMenuView?.setItemViews(items)
        dropMenuView?.setSkin(self.skin)
        var fromRect = sender.convert(sender.bounds, to: view)
        fromRect.origin.y += fromRect.height * 0.7
        fromRect.size = fromRect.size * 0.2
        showDropMenu(dropMenuView!, from: fromRect, offset: CGPoint(0.0, 0.0))
    }
}



