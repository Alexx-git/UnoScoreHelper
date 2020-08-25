//
//  GameSession+Editing.swift
//  GameCountHelper
//
//  Created by Vlad on 7/5/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension GameSessionViewController {
//    
//    func editFieldAddString(_ string: String) {
//        
//        if let selection = editSelection {
//            if selection.label.text == "-" {
//                selection.label.text = string
//            }
//            else {
//                selection.label.text? += string
//            }
//            let round = game.rounds[selection.row]
//            let player = game.players[selection.col]
//            round.score[player.id] = Int(selection.label.text ?? "0")
//        }
//        else {
////            editingView.currentField?.text? += string
//        }
//    }
    
    func editLabel(row: Int, column: Int) {
        let editRoundVC = EditRoundViewController(players: game.players)
        editRoundVC.roundNumber = row + 1
        let round = game.rounds[row]
        editRoundVC.values = game.players.map{(round.score[$0.id] ?? 0)}
        editRoundVC.onOk = { [unowned self] scores in
            for (index, player) in self.game.players.enumerated() {
                round.score[player.id] = scores[index]
            }
            if let skin = self.skin {
                self.updateSkin(skin)
            }
            self.updateResults()
        }
        let view = editRoundVC.view
        editRoundVC.selectLabel(editRoundVC.editLabels[column])
        self.present(editRoundVC, animated: true, completion: nil)
    }
        
    func setEditSelection(_ selection: RowEditSelection) {
        if let editSelection = editSelection {
            editSelection.label.state = .normal
//            editSelection.label.layer.cornerRadius = 0.0
        }
        editSelection = selection
        editSelection?.label.state = .selected
        editSelection?.label.layer.cornerRadius = 5.0
        editSelection?.label.clipsToBounds = true
    }
    
    func onNumPadAddValue(_ value: String) {
        if let label = editSelection?.label {
            if label.text?.count ?? 0 >= GameManager.shared.settings.digitLimit {
                showDigitLimitAlert()
            } else if label.text == "-" {
                label.text = value
            } else {
                label.text = (label.text ?? "") + value
            }
        }
        update()
    }
    
    func onNumPadBackspace() {
        if let label = editSelection?.label {
            if (label.text?.count ?? 0) < 2 {
                label.text = "-"
            } else {
                label.text?.removeLast()
            }
        }
        update()
    }
    
    func update() {
        guard let (label, row, column) = editSelection else {return}
        let value = label.text
        let player = game.players[column]
        let round = game.rounds[row]
        if value == "-" {
            round.score[player.id] = 0
        } else {
            round.score[player.id] = Int(value ?? "0")
        }
        updateResults()
        tableView.reloadData()
    }
    
    func onNumPadOK() {
        
        if ??self.game.rounds.last?.hasValues {
            self.game.newRound(with: nil) 
        }
        tableView.reloadData()
        editSelection?.label.state = .normal
        editSelection = nil
//        editSelection?.label.layer.cornerRadius = 0.0
        
    }
    
    func showDigitLimitAlert() {
        showInfoAlert(title: "Too long!", message: "You may not input values with more than \(GameManager.shared.settings.digitLimit) digits")
    }
}
