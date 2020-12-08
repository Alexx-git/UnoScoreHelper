//
//  SkinsViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class SkinsViewController: TopBarViewController, UITableViewDataSource, UITableViewDelegate {

    let checkView = CheckButtonView()
    let segmentedControl = UISegmentedControl(items: ["Light mode".ls, "Dark mode".ls])
    let tableView = UITableView()
    var skins = [Skin]()
    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.items = [
            tableView.boxed
        ]
        SkinTableViewCell.register(tableView: tableView)
        
        checkView.title = "Use one theme for all modes".ls
        checkView.numberOfLines = 0
        tableView.backgroundColor = .clear
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
    
    override func updateViewContent() {
        super.updateViewContent()
        let headerView = UIView()
        headerView.addBoxItem(checkView.boxed.allX(16.0))
        var rect = view.bounds
        rect.size.height = 50.0
        headerView.frame = rect
        tableView.tableHeaderView = headerView
    }
    
    override func updateSkin(_ skin: Skin)
    {
        super.updateSkin(skin)
        checkView.fontScale = 0.5
        checkView.setSkinGroups([.button: skin.barButton])
//        let editableSkinGroups = [SkinKey.label: skin.editableNumbers]

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SkinTableViewCell.dequeue(tableView: tableView)
        let skin = skins[indexPath.row]
        cell.skinLabel.textAlignment = .center
        cell.skinLabel.text = skin.name
        cell.borderView.setBrush(skin.cell)
        cell.skinLabel.setSkinStyle(skin.bigTitle)
        if let img = skin.imageForKey(.bg) {
            cell.borderView.backgroundColor = UIColor(patternImage: img)
        }
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
    let borderView = BoxView()
    let skinLabel = SkinLabel()

    override func setup() {
        super.setup()
        boxView.items = [borderView.boxed]
        borderView.items = [skinLabel.boxed.all(16.0)]
        borderView.layer.cornerRadius = 10.0
        contentView.backgroundColor = .clear
        boxView.backgroundColor = .clear
        skinLabel.adjustsFontSizeToFitWidth = true
    }

}
