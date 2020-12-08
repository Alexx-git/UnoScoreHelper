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
    
    var labels = [SkinLabel]()

    override func setupViewContent() {
        super.setupViewContent()
        setupMenuItems()
        contentBoxView.items = [scrollView.boxed]
        boxView.insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        scrollView.addBoxItem(boxView.boxed)
        boxView.bxPinWidth(.zero, to: scrollView)
        
        let introTextLabel = addTextLabel(with: "This app is build in order to provide simple and useful tool for counting numeric game scores.")
        labels.append(introTextLabel)
        
        let beginTextLabel = addTextLabel(with: "When you open CountHelper, you'll see the last played game if you have any, or the new game screen if not.")
        labels.append(beginTextLabel)
        
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
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        let rowSkinGroups = [SkinKey.label: skin.text.normalGroup]
        for label in labels {
            label.setSkinGroups(rowSkinGroups)
        }
    }
}
