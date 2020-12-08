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
        tableView.bxPinHeight(>=1.0)
        tableView.setContentCompressionResistancePriority(.required, for: .vertical)
        tableView.separatorInset = .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sepView = UIView()
        sepView.backgroundColor = skin?.divider.fill ?? .clear
        return sepView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("game.rounds.count: \(game.rounds.count)")
        return game.rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RoundTableViewCell.dequeue(tableView: tableView)
        let isCompactRows = view.bounds.size.hasSmallHeight
        let yInset: CGFloat = (isCompactRows) ? 2.0 : 4.0
        cell.rowView.insets = UIEdgeInsets.allX(12.0).allY(yInset)
        cell.rowView.numberLabel.text = "\(indexPath.row + 1)"
        cell.rowView.numberWidth = roundViewIndexWidth
        cell.rowView.setRow(values: valuesInPlayerOrder(for: game.rounds[indexPath.row]))
        let round = game.rounds[indexPath.row]
        cell.rowView.spacing = columnSpacing
        cell.rowView.tag = indexPath.row
        cell.rowView.tapHandler = rowLabelTapHandler
//        if let font = minFont {
//            cell.rowView.setFont(font: font)
//        }
        for (index, label) in cell.rowView.labels.enumerated() {
            let player = game.players[index]
            let score = round.score[player.id] ?? 0
            if score == 0 {
                label.text = "-"
            } else {
                label.text = "\(score)"
            }
        }
        cell.rowView.maxAllowedFontSize = (isCompactRows) ? 18.0 : 36.0
        cell.rowView.setSkinGroups(rowSkinGroups)
        guard let selection = editSelection else {return cell}
        if indexPath.row == selection.row {
            editSelection!.label = cell.rowView.labels[selection.col]
            editLabelSetSelected()
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if rowHeight == nil {
//            rowHeight = cell.frame.height
//        }
//     }
        
    
}
