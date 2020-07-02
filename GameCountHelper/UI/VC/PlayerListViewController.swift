//
//  PlayerListViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/22/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit



class PlayerListViewController: TopBarViewController, UITableViewDelegate, UITableViewDataSource {
        
    let tableView = UITableView()
    
    var players = [Player]()
    
    var handler: EditPlayerViewController.Handler?
    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.items = [tableView.boxed]
        tableView.dataSource = self
        tableView.delegate = self
        PlayerTableViewCell.register(tableView: tableView)
        AddPlayerTableViewCell.register(tableView: tableView)
        setupMenuItems()
    }
        
    func setupMenuItems() {
        topBarView.titleLabel.text = "Choose player"
        
        topBarView.leftButton.setTitle("Cancel".ls)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.navigationController?.popViewController(animated: true)
        }

//        topBarView.rightButton.setTitle("Save".ls)
//        topBarView.rightButton.onClick = { [unowned self] btn in
//
//        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            handler?(players[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
        else {
            let newPlayerVC = EditPlayerViewController() { [weak self]  player in
                guard let self = self else { return }
                self.handler?(player)
                self.navigationController?.popToRootViewController(animated: true)
            }
            navigationController?.pushViewController(newPlayerVC, animated: true)
        }
    }
    
// MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return players.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = PlayerTableViewCell.dequeue(tableView: tableView)
            let player = players[indexPath.row]
            cell.label.text = player.name
            if let image = player.image {
                cell.avatar = image
            }
            cell.removeButton.setTitle("Delete")
            cell.removeButton.onClick = {btn in
                self.deletePlayer(number: indexPath.row)
            }
            return cell
        } else {
            let cell = AddPlayerTableViewCell.dequeue(tableView: tableView)
            cell.plusImageView.image = .template("plus")
            cell.label.text = "New Player"
            if let brush = skin?.barButton.styleForState(.normal)?.textDrawing?.brush {
                cell.plusImageView.setImageBrush(brush)
            }
            
            return cell
        }
        
    }
    
    func deletePlayer(number: Int) {
        let player = players[number]
        players.remove(at: number)
        viewContext.delete(player)
        tableView.reloadData()
    }
}
