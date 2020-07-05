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
    
    let playersRowView = PlayerHeaderRowView()
    let titleDivView = DivView()
    let tableView = ContentSizedTableView.newAutoLayout()
    let newRoundButton = SkinButton.newAutoLayout()
    let resultDivView = DivView()
    let resultRowView = RowView()
    let numPadView = NumPadInputView()
    var ownSize: CGSize = .zero
    
    var timer: Timer = Timer()
    var timerStartTime: Date = Date(timeIntervalSinceNow: 0.0)
    var timeElapsedBefore: TimeInterval = 0.0
    
    var tableHeight: NSLayoutConstraint?
    var rowSkinGroups = [SkinKey: SkinGroup]()
    var roundViewIndexWidth: CGFloat = 0.0
    
    var editSelection: RowEditSelection?
    var rowLabelTapHandler: RowView.LabelTapHandler?
    
    var minAllowedFontSize: CGFloat = 16.0
    var minFont: UIFont?
    
    let columnSpacing: CGFloat = 5.0
    
    

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
        numPadView.setupWithHandler { [unowned self] btnType in
            print("btnType: \(btnType)")
            switch btnType {
                case .num(let value): self.onNumPadAddValue("\(value)")
                case .delete: self.onNumPadBackspace()
                case .ok: self.onNumPadOK()
                default: ()
            }
        }
        setupMenuItems()
        topBarView.titleLabel.text = "00:00"
        bgImageView.alpha = 0.5
        view.backgroundColor = .green
        updateItems()
        updateLayoutIfNeed()
        playersRowView.insets = .all(12.0)
        playersRowView.spacing = columnSpacing
        playersRowView.numberLabel.text = "#".ls
        setupTableView()
        
        newRoundButton.setTitle("New Round".ls)
        newRoundButton.layer.cornerRadius = 10.0
        newRoundButton.onClick = { [unowned self] btn  in
            self.clickedNewRoundButton()
        }
        
        resultRowView.insets = UIEdgeInsets.allY(8.0).allX(12.0)
        resultRowView.spacing = columnSpacing
        updateResults()

        self.startTimer()
        
        tableView.onSizeUpdate = { [unowned self] sz in
            let minHeight = 1.f
            let height = (sz.height >= minHeight) ? sz.height : minHeight
            if let tableHeight = self.tableHeight {
                tableHeight.constant = height
                if height > 1.0 {
                    print("self.view: \(self.view)")
                    self.view.layoutIfNeeded()
                }
            }
            else {
                self.tableHeight = self.tableView.bxPinHeight(<=height)
            }
        }
        
        rowLabelTapHandler = { [unowned self] rowView, label in
            if GameManager.shared.settings.inPlaceEditing {
                if let col = rowView.labels.firstIndex(of: label) {
                    let selection = (label, rowView.tag, col)
                    self.setEditSelection(selection)
                }
            }
            else {
                self.editRowAtIndex(rowView.tag)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayoutIfNeed()
    }
    
    func updateLayoutIfNeed() {
        if ownSize != view.bounds.size {
            ownSize = view.bounds.size
            updateLayout()
        }
    }
    
    func updateLayout() {
        if GameManager.shared.settings.inPlaceEditing {
            var rowCount = 1
            print("ownSize: \(ownSize)")
            if ownSize.height > ownSize.width * 1.5 {
                rowCount = 4
            }
            else if ownSize.height > ownSize.width * 0.75 {
                rowCount = 2
            }
            numPadView.rowCount = rowCount
        }
    }
    

    override func updateViewContent() {
        super.updateViewContent()
        playersRowView.setRow(texts: game.players.map{$0.name ?? ""})
        playersRowView.setRow(images: game.players.map{$0.image ?? nil})
    }
    
    
    override func updateSkin(_ skin: Skin) {
        super.updateSkin(skin)
        let font = skin.h1.textDrawing?.font
        
        roundViewIndexWidth = font?.rectSizeForText("444", fontSize: font?.pointSize ?? 16).width ?? 0
//        let titleGroups = SkinKey.label.groupsWithNormalStyle(skin.h1)
        let divGroup = Skin.State.normal.groupWithStyle(Skin.Style(box: skin.divider, textDrawing: nil))
        let titleGroups = [SkinKey.label: skin.letterStyles.group, SkinKey.divider: divGroup]
        playersRowView.setSkinGroups(titleGroups)
        let scoreGroups = [SkinKey.label: skin.editableNumbers, SkinKey.divider: divGroup]

        rowSkinGroups = scoreGroups
        titleDivView.setBrush(skin.divider)
        resultDivView.setBrush(skin.divider)
        resultRowView.setSkinGroups(titleGroups)
        newRoundButton.setSkinGroups([SkinKey.button: skin.keyStyles])
        tableView.separatorColor = skin.divider.fill
        
        numPadView.setSkin(skin)
        playersRowView.numberWidth = roundViewIndexWidth
        resultRowView.numberWidth = roundViewIndexWidth
//        editingView.setSkinGroups(SkinKey.textField.groupsWithNormalStyle(skin.h1))
//        playersRowView.adjustFont()
        adjustFont()
    }
    
    func updateItems() {
        let inPlace = GameManager.shared.settings.inPlaceEditing
        if inPlace {
            if !(??self.game.rounds.last?.hasValues) {
                self.game.newRound(with: nil)
            }
        }
        contentBoxView.optItems = [
            playersRowView.boxed,
            titleDivView.boxed,
            tableView.boxed,
            resultDivView.boxed,
            resultRowView.boxed,
            newRoundButton.boxed.all(16.0).bottom(0.0).useIf(!inPlace),
            numPadView.boxed.all(16.0).bottom(0.0).useIf(inPlace),
            BoxItem.guide().height(0.0).bottom(>=16.0)
        ]
    }
    


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
        adjustFont()
        mainAsyncAfter(0.1) {
//            if self.rowHeight != nil {
//                self.updateTableHeight(animated: true)
//            }
            self.resultRowView.numberLabel.text = ":"
            self.resultRowView.setRow(values: values.map{"\($0)"})
            var lastRound = self.game.rounds.count
            if lastRound > 0 {
                lastRound -= 1
//                self.tableView.scrollToRow(at: IndexPath(row:  lastRound, section: 0), at: .bottom, animated: true)
            }
            self.tableView.reloadData()
//            self.tableView.onSizeUpdate?(self.tableView.contentSize)
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
    

    
    func clickedNewRoundButton() {
        let newRoundVC = EditRoundViewController(players: game.players)
        newRoundVC.roundNumber = game.rounds.count + 1
        newRoundVC.onOk = { [unowned self] scores in
            self.game.newRound(with: scores)
//            if let skin = self.skin {
//                self.updateSkin(skin)
//            }
            self.updateResults()
        }
        self.present(newRoundVC, animated: true, completion: nil)
    }
    
//    func shufflePlayersIn(order players: [Player]) {
//        game.players = players
//        updateViewContent()
//        updateResults()
//    }
    
    func adjustFont() {
        var maxCount = 0
        var maxScores = [Int]()
        for round in game.rounds {
            for score in round.score.values {
                let count = "\(score)".count
                if count > maxCount {
                    maxCount = count
                    maxScores = [score]
                } else if count == maxCount {
                    maxScores.append(score)
                }
            }
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RoundTableViewCell else {return}
        guard let font = cell.rowView.labels.first?.font else {return}
        var minSize: CGFloat = 40.0
        let labelWidth = playersRowView.elementWidth()
        let size = CGSize(width: labelWidth, height: 40.0)
        for score in maxScores {
            guard let text = "\(score)" as? NSString else {continue}
            minSize = min(minSize, font.maxFontSizeForText(text, in: size))
        }
        minFont = font.withSize(max(minSize, minAllowedFontSize))
//        tableView.reloadData()
//        self.view.layoutIfNeeded()
    }

}

//extension GenericRowView<Element> where Element: PlayerHeaderView {
//    func adjustFont() {
//        var minSize: CGFloat = 40.0
//        
//        let width = elementWidth()
//        let size = CGSize(width: width, height: 40.0)
//        guard let font = elements.first?.label.font else {return}
//        for element in elements {
//            guard let text = element.label.text as? NSString else {continue}
//            minSize = min(minSize, font.maxFontSizeForText(text, in: size))
//        }
//        let minFont = font.withSize(max(minSize, minAllowedFontSize))
//        setFont(font: minFont)
//    }
//    
//    func setFont(font: UIFont) {
//        
//    }
//}
