//
//  GameSessionViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit
import BoxView

class GameSessionViewController: TopBarViewController, UITableViewDataSource, UITableViewDelegate {

    typealias RowEditSelection = (label: SkinLabel, row: Int, col: Int)
    
    let game: GameSession
    
    let playersRowView = RowView()
    let titleDivView = DivView()
    let tableView = ContentSizedTableView.newAL()
    let resultDivView = DivView()
    let resultRowView = RowView()
//    let editingView = GameRoundEditingView()
//    let numPadView = NumPadInputView()
    
    var timer: Timer = Timer()
    var timerStartTime: Date = Date(timeIntervalSinceNow: 0.0)
    var timeElapsedBefore: TimeInterval = 0.0
    
    var tableHeight: NSLayoutConstraint?
//    var tableHeightIsUpdatedByRound: Bool = false
//    var rowHeight: CGFloat? = nil
    var rowSkinGroups = [SkinKey: SkinGroup]()
    var roundViewIndexWidth: CGFloat = 0.0
    
    var editSelection: RowEditSelection?
    var rowLabelTapHandler: RowView.LabelTapHandler?

    //MARK: - Inits
    
    init(game: GameSession) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Overriden methods
    
    override func setupViewContent() {
        
        super.setupViewContent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        setupMenuItems()
        topBarView.titleLabel.text = "00:00"
        bgImageView.alpha = 0.5
        view.backgroundColor = .green

        contentBoxView.items = [
            playersRowView.boxZero,
            titleDivView.boxZero,
            tableView.boxZero,
            resultDivView.boxZero,
            resultRowView.boxBottom(>=0.0)
        ]
        
        playersRowView.insets = UICommon.insets
        
        playersRowView.numberLabel.text = "#".ls
        setupTableView()
        
        resultRowView.insets = UICommon.insets
        updateResults()

        self.startTimer()
        
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
        
        rowLabelTapHandler = { [unowned self] rowView, label in
            if let col = rowView.labels.firstIndex(of: label) {
                let selection = (label, rowView.tag, col)
                self.setEditSelection(selection)
            }
                
        }
    }

    override func updateViewContent() {
        super.updateViewContent()
        playersRowView.setRow(values: game.players.map{$0.name ?? ""})
//        editingView.setFieldCount(game.players.count)

    }
    
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        let font = skin.h1.textDrawing?.font
        
        roundViewIndexWidth = font?.rectSizeForText("444", fontSize: font?.pointSize ?? 16).width ?? 0
        let titleGroups = SkinKey.label.groupsWithNormalStyle(skin.h1)
        playersRowView.setSkinGroups([SkinKey.label: skin.letterStyles.group])        
        rowSkinGroups = [SkinKey.label: skin.editableNumbers]
        titleDivView.setBrush(skin.divider)
        resultDivView.setBrush(skin.divider)
        resultRowView.setSkinGroups(titleGroups)
//        numPadView.setSkin(skin)
        playersRowView.numberWidth = roundViewIndexWidth
        resultRowView.numberWidth = roundViewIndexWidth
//        editingView.setSkinGroups(SkinKey.textField.groupsWithNormalStyle(skin.h1))
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//    }
    
    
    func valuesInPlayerOrder(for round: Round) -> [String] {
        return game.players.map{"\(round.score[$0.id] ?? 0)"}
    }
    

    
    //MARK: - Rounds
    

    
    func updateResults() {
        var values = [Int](repeating: 0, count: game.players.count)
        for round in game.rounds {
            for (index, player) in game.players.enumerated() {
                values[index] += round.score[player.id] ?? 0
            }
        }
        
//        editingView.editFields.forEach{$0.text = ""}
//        editingView.editFields.first?.becomeFirstResponder()
//        if self.rowHeight != nil {
//            self.tableHeightIsUpdatedByRound = true
//        }
        tableView.reloadData()
        mainAsyncAfter(0.1) {
//            if self.rowHeight != nil {
//                self.updateTableHeight(animated: true)
//            }
            self.resultRowView.setRow(values: values.map{"\($0)"})
            var lastRound = self.game.rounds.count
            if lastRound > 0 {
                lastRound -= 1
                self.tableView.scrollToRow(at: IndexPath(row:  lastRound, section: 0), at: .bottom, animated: true)
            }
            
        }
    }
    
    func editFieldDeleteLast() {
        if let selection = editSelection {
            if let text = selection.label.text {
                if text.count == 1 {
                   selection.label.text = "-"
                }
                else {
                    selection.label.text = String(text.dropLast())
                }
      
            }
            let round = game.rounds[selection.row]
            let player = game.players[selection.col]
            round.score[player.id] = Int(selection.label.text ?? "0")
        }
//            for round in game.rounds {
//                for (index, player) in game.players.enumerated() {
//                    values[index] += round.score[player.id] ?? 0
//                }

        else {
//            editingView.currentField?.deleteBackward()
        }
    }
    
    func editFieldAddString(_ string: String) {
        
        if let selection = editSelection {
            if selection.label.text == "-" {
                selection.label.text = string
            }
            else {
                selection.label.text? += string
            }
            let round = game.rounds[selection.row]
            let player = game.players[selection.col]
            round.score[player.id] = Int(selection.label.text ?? "0")
        }
        else {
//            editingView.currentField?.text? += string
        }
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
    
    func clickedNewRoundButton() {
        let newRoundVC = NewRoundViewController(players: game.players)
        newRoundVC.roundNumber = game.rounds.count + 1
        newRoundVC.onOk = { [unowned self] scores in
            self.game.newRound(with: scores)
            if let skin = self.skin {
                self.updateSkin(skin)
            }
            self.updateResults()
        }
        self.present(newRoundVC, animated: true, completion: nil)
    }
    
    func shufflePlayersIn(order players: [Player]) {
        game.players = players
        updateViewContent()
        updateResults()
    }

}
