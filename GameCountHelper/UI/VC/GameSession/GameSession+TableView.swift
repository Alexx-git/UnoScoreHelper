//
//  GameSessionViewController+TableView.swift
//  GameCountHelper
//
//  Created by Vlad on 5/29/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

extension GameSessionViewController {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        RoundTableViewCell.register(tableView: tableView)
        tableView.alPinHeight(>=10.0)
        tableView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return game.players[0].rounds.count
        return game.rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RoundTableViewCell.dequeue(tableView: tableView)
        cell.rowView.numberLabel.text = "\(indexPath.row + 1)"
        cell.rowView.numberWidth = roundViewIndexWidth
        cell.rowView.setRow(values: valuesInPlayerOrder(for: game.rounds[indexPath.row]))
        let round = game.rounds[indexPath.row]
        cell.rowView.tag = indexPath.row
        cell.rowView.tapHandler = rowLabelTapHandler
        for (index, label) in cell.rowView.labels.enumerated() {
            let player = game.players[index]
            let score = round.score[player.id] ?? 0
            if score == 0 {
                label.text = "-"
            } else {
                label.text = "\(score)"
            }
        }
        cell.rowView.setSkinGroups(rowSkinGroups)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if rowHeight == nil {
//            rowHeight = cell.frame.height
//        }
//     }
        
    
}
