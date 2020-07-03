//
//  AboutViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 7/3/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class AboutViewController: BaseViewController {
    
    let scrollView = UIScrollView()
    
    let boxView = BoxView()

    override func setupViewContent() {
        super.setupViewContent()
        view.addBoxItem(scrollView.boxed)
        scrollView.addBoxItem(boxView.boxed)
        boxView.bxPinWidth(.zero, to: scrollView)
        boxView.bxPinHeight(.zero, to: scrollView).priority = .defaultLow
        let label = SkinLabel()
        label.text = ""
        boxView.items = [label.boxed]
    }

}
