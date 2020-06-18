//
//  SkinsViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class SkinsViewController: TopBarViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    var skins = [Skin]()
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.items = [tableView.boxZero]
        SkinTableViewCell.register(tableView: tableView)
        
        tableView.backgroundColor = .gray
        tableView.separatorColor = .clear

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupBackButton()
        topBarView.titleLabel.text = "Skins"
        skins = SkinManager.loadSkins()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SkinTableViewCell.dequeue(tableView: tableView)
        let skin = skins[indexPath.row]
        cell.contentView.backgroundColor = skin.bgColor
        cell.skinLabel.backgroundColor = skin.bgColor
        cell.skinLabel.text = skin.name
        cell.skinLabel.setSkinStyle(skin.titlesText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < skins.count {
            GameManager.shared.setSkin(skins[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }

}

class SkinTableViewCell: BaseTableViewCell {
    let skinLabel = SkinLabel()

    override func setup() {
        super.setup()
        boxView.items = [skinLabel.boxZero]
        contentView.backgroundColor = .lightGray
        skinLabel.adjustsFontSizeToFitWidth = true
    }

}
