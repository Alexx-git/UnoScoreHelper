//
//  PlayerHeaderRowView.swift
//  GameCountHelper
//
//  Created by Vlad on 7/2/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class PlayerHeaderRowView: ElementRowView {

    override func newElement() -> RowElement {
        let header = PlayerHeaderView()
        header.label?.textAlignment = .center
        return header
    }
    
    func setRow(images: [UIImage?]) {
        if elements.count != images.count {
            createElements(count: images.count)
        }
        for (index, element) in elements.enumerated() {
            (element as! PlayerHeaderView).image = images[index]
        }
    }
    
    func setLayoutOrientation(orientation: BoxLayout.Axis) {
        for element in elements {
            let header = element as! PlayerHeaderView
            header.axis = orientation
            header.updateItems()
        }
    }

}
