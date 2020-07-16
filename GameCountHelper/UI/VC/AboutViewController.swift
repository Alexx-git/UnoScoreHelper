//
//  AboutViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 7/3/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class AboutViewController: TopBarViewController {
    
    let scrollView = UIScrollView()
    
    let boxView = BoxView()

    override func setupViewContent() {
        super.setupViewContent()
        setupMenuItems()
        contentBoxView.items = [scrollView.boxed]
        scrollView.addBoxItem(boxView.boxed)
        boxView.bxPinWidth(.zero, to: scrollView)
        boxView.bxPinHeight(.zero, to: scrollView).priority = .defaultLow
        let introTextLabel = addTextLabel(with: "This app is build in order to provide simple and useful tool for counting numeric scores for a couple of players.")
        let beginTextLabel = addTextLabel(with: "When you open CountHelper, you'll see the last unfinished game if you have any, or the new game screen if not.")
        boxView.items = [
            introTextLabel.boxed,
            beginTextLabel.boxed
        ]
    }
    
    func setupMenuItems() {
        topBarView.titleLabel.text = "About".ls
        topBarView.leftButton.setImage(UIImage.template("back"))
        topBarView.leftButton.contentEdgeInsets = .allX(8.0)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addTextLabel(with text: String) -> SkinLabel {
        let label = SkinLabel()
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    func addTitleLabel(with text: String) -> SkinLabel {
        let label = SkinLabel()
        label.text = text
        return label
    }
}
