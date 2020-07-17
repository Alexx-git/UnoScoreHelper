//
//  UIViewController+InfoAlert.swift
//  GameCountHelper
//
//  Created by Vlad on 7/17/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
