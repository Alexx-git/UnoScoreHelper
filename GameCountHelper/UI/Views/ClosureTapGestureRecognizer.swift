//
//  ClosureTapGestureRecognizer.swift
//  Crypto
//
//  Created by Vlad on 4/18/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

typealias TapGestureRecognizerHandler = (UITapGestureRecognizer) -> ()

class ClosureTapGestureRecognizer: UITapGestureRecognizer {
    
    
    func addToView(_ view: UIView, handler: @escaping TapGestureRecognizerHandler) {
        self.onTap = handler
        view.addGestureRecognizer(self)
    }

    
    @objc
    private func didTapRecognizer(_ recognizer: UITapGestureRecognizer) {
        onTap?(self)
    }
    
    var onTap: TapGestureRecognizerHandler? {
        didSet {
            let sel = #selector(didTapRecognizer(_ :))
            if onTap != nil {
                self.removeTarget(self, action: sel)
                self.addTarget(self, action: sel)
            } else {
                self.removeTarget(self, action: sel)
            }
        }
    }
    

}
