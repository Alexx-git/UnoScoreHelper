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
    
    func editRowAtIndex(_ rowIndex: Int) {
        let editRoundVC = EditRoundViewController(players: game.players)
        editRoundVC.roundNumber = rowIndex + 1
        let round = game.rounds[rowIndex]
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
        self.present(editRoundVC, animated: true, completion: nil)
    }
        
    func setEditSelection(_ selection: RowEditSelection) {
        if let editSelection = editSelection {
            editSelection.label.state = .normal
            editSelection.label.layer.cornerRadius = 0.0
        }
        editSelection = selection
        editSelection?.label.state = .selected
        editSelection?.label.layer.cornerRadius = 5.0
    }
    
    func onNumPadAddValue(_ value: String) {
        if let label = editSelection?.label {
            if label.text == "-" {
                label.text = value
            } else {
                label.text = (label.text ?? "") + value
            }
        }
    }
    
    func onNumPadBackspace() {
        if let label = editSelection?.label {
            if (label.text?.count ?? 0) < 2 {
                label.text = "-"
            } else {
                label.text?.removeLast()
            }
        }
    }
    
    func onNumPadOK() {
        if ??self.game.rounds.last?.hasValues {
            self.game.newRound(with: nil)
            tableView.reloadData()
        }
        editSelection?.label.state = .normal
        editSelection?.label.layer.cornerRadius = 0.0
        
    }
}
