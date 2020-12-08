//
//  BaseViewController.swift
//  Crypto
//
//  Created by VLADIMIR on 12/25/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

import UIKit
import BoxView

class BaseViewController: UIViewController, CommonDataAccess {

    var didSetupConstraints = false
    
    var skin: Skin?
    
    let bgImageView = UIImageView()
    
    var spinnerView: UIActivityIndicatorView? = nil
    var spinnerBackgroundView: UIView? = nil
    
    var dropMenuView: DropMenuView?
    
    let safeView = BoxView()
    
    override func viewDidLoad() {
        print(">>self: \(self)")
        super.viewDidLoad()
        setupViewContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
        updateViewContent()
        updateSkin(GameManager.shared.skin)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            // Either .unspecified, .light, or .dark
            let userInterfaceStyle = traitCollection.userInterfaceStyle
        } 
        
    }

    
    func setupViewContent() {
//        view.addSubview(bgImageView)
        bgImageView.contentMode = .scaleAspectFill
        if #available(iOS 11, *) {
            view.addSubview(safeView)
            view.safeAreaLayoutGuide.addBoxItems([safeView.boxed])
        }
        else {
            view.addBoxItems([safeView.boxed])
        }
    }
    
    func updateViewContent() {
       
    }
    
    func updateSkin(_ skin: Skin) {
        self.skin = skin
        bgImageView.image = skin.imageForKey(.main)
        self.view.backgroundColor = skin.bgColor
        dropMenuView?.setSkin(skin)
    }
    
    func showSpinner() {
        guard spinnerView == nil else {return}
        spinnerBackgroundView = UIView()
        spinnerBackgroundView?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.addSubview(spinnerBackgroundView!)
        view.bringSubviewToFront(spinnerBackgroundView!)
        spinnerBackgroundView?.autoPinEdgesToSuperviewEdges()
        spinnerView = UIActivityIndicatorView(style: .gray)
        spinnerBackgroundView!.addSubview(spinnerView!)
        spinnerView?.autoCenterInSuperview()
        spinnerView?.startAnimating()
    }
    
    func removeSpinner() {
        guard spinnerView != nil else {return}
        spinnerView?.stopAnimating()
        spinnerView?.removeFromSuperview()
        spinnerView = nil
        spinnerBackgroundView?.removeFromSuperview()
        spinnerBackgroundView = nil
    }
    
}

extension CGSize {
    var hasSmallHeight: Bool {
        return height < 500.0
    }
}
