//
//  BaseViewController.swift
//  Crypto
//
//  Created by VLADIMIR on 12/25/18.
//  Copyright © 2018 ALEXANDER. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, CommonDataAccess {

    var didSetupConstraints = false
    
    var skin: Skin?
    
    let bgImageView = UIImageView()
    
    var spinnerView: UIActivityIndicatorView? = nil
    var spinnerBackgroundView: UIView? = nil
    
    var dropMenuView: DropMenuView?
    
    override func viewDidLoad() {
        print(">>self: \(self)")
        super.viewDidLoad()
        setupViewContent()
        self.setupViewConstraints()
        self.setupOwnViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
        updateViewContent()
        updateSkin(GameManager.shared.skin)
    }
    
    public func setupViewConstraints() {
//        bgImageView.autoPinEdgesToSuperviewEdges()
    }
    
    public func setupOwnViewConstraints() {
        //to override: setup View constraints only for this class (not for subclasses)
        //so don't call super.setupViewConstraints()
    }
    
    func setupViewContent() {
//        view.addSubview(bgImageView)
        bgImageView.contentMode = .scaleAspectFill

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
