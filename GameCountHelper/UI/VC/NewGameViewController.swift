//
//  NewGameViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 5/9/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, UITableViewDataSource {
    
    let game = GameSession.newInstance(for: [])
    
    let tableView = UITableView()
    
    let newPlayerButton = ClickButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        PlayerTableViewCell.register(tableView: tableView)
        view.addSubview(newPlayerButton)
        newPlayerButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        newPlayerButton.autoSetDimension(.height, toSize: 50.0)
        newPlayerButton.autoPinEdge(.top, to: .bottom, of: tableView)
        newPlayerButton.backgroundColor = .orange
        newPlayerButton.setTitle("New Player", for: .normal)
        newPlayerButton.onClick = {btn in
            self.newPlayer()
        }
    }
    
    func newPlayer() {
        typealias alertActionHandler = ((UIAlertAction) -> Void)
        let placeholder = "Player"// \(self.game.player_set.players.count + 1)
        var alertController = UIAlertController(title: "New Player",
        message: "Enter player name",
        preferredStyle: .alert)
        alertController.addTextField(
            configurationHandler: {(textField: UITextField!) in
                textField.placeholder = placeholder
        })
        let actionHandler:alertActionHandler = {[weak self] (paramAction: UIAlertAction) in
            self?.addPlayer(name: alertController.textFields?.first?.text ?? placeholder)
        }
        let action = UIAlertAction(title: "Done",
                                   style: .default,
                                   handler: actionHandler)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func addPlayer(name: String) {
        DispatchQueue.main.async {
            let player = Player.newInstance()
            player.name = name
//            self.game.player_set.players.append(player)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PlayerTableViewCell.dequeue(tableView: tableView)
//        cell.label.text = game.player_set.players[indexPath.row].name
        return cell
    }
}
