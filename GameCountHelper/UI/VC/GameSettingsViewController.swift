//
//  GameSettingsViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/22/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class GameSettingsViewController: TopBarViewController, UITableViewDelegate, UITableViewDataSource {
    
    var players = [Player]()
    
    let tableView = ContentSizedTableView.newAL()
    var tableHeight: NSLayoutConstraint?
    
    let startButton = SkinButton()
    
    override func setupViewContent() {
        super.setupViewContent()
        contentBoxView.items = [
            tableView.boxZero,
            startButton.boxTopBottom(==0.0, >=0.0)
        ]
        setupTableView()
        startButton.alPinHeight(100.0)
        startButton.setTitle("Start Game".ls)
        startButton.onClick = { [unowned self] btn in
            let sessionVC = GameSessionViewController(game: GameManager.shared.newSession(with: self.players))
            self.navigationController?.pushViewController(sessionVC, animated: true)
        }
        
        setupMenuItems()
        tableView.onSizeUpdate = { [unowned self] sz in
            print("sz.height: \(sz.height)")
            let height = (sz.height >= 10.0) ? sz.height : 10.0
            if let tableHeight = self.tableHeight {
                tableHeight.constant = height
                if height > 10.0 {
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            else {
                self.tableHeight = self.tableView.alPinHeight(<=height)
            }
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        PlayerTableViewCell.register(tableView: tableView)
        AddPlayerTableViewCell.register(tableView: tableView)
        tableView.alPinHeight(>=10.0)
        tableView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
        
    func setupMenuItems() {
        topBarView.titleLabel.text = "Players"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let playerVC = EditPlayerViewController(player: players[indexPath.row]) { [weak self]  player in
                guard let self = self else { return }
                self.players[indexPath.row] = player
                tableView.reloadData()
            }
            navigationController?.pushViewController(playerVC, animated: true)
        } else {
            addPlayer()
        }
        
    }
    
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
            cell.deleteButton.setImage(UIImage(named: "remove"))
            cell.deleteButton.onClick = {btn in
                self.removePlayer(number: indexPath.row)
            }
            return cell
        } else {
            let cell = AddPlayerTableViewCell.dequeue(tableView: tableView)
            cell.plusImageView.image = UIImage(named: "plus")
            cell.label.text = "Add Player"
            return cell
        }
        
    }
    
    func updateWithPlayer(_ player: Player?) {
        if let player = player {
            self.players.append(player)
            self.tableView.reloadData()
        }
    }
    
    func addPlayer() {
        let allPlayers = Player.fetchAllInstances(in: viewContext)
        let otherPlayers = allPlayers.filter{!players.contains($0)}
        if otherPlayers.count == 0 {
            let newPlayerVC = EditPlayerViewController() { [weak self]  player in
                guard let self = self else { return }
                self.updateWithPlayer(player)
            }
            navigationController?.pushViewController(newPlayerVC, animated: true)
        }
        else {
            let listVC = PlayerListViewController()
            listVC.players = otherPlayers
            listVC.handler = { player in
                self.updateWithPlayer(player)
            }
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    func removePlayer(number: Int) {
        let player = players[number]
        players.remove(at: number)
        tableView.reloadData()
    }

}
