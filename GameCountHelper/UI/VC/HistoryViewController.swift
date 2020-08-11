//
//  HistoryViewController.swift
//  GameCountHelper
//
//  Created by Vlad on 7/10/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

class HistoryViewController: TopBarViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    
    var items = [GameSession]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuItems()
        HistoryTableViewCell.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        contentBoxView.items = [tableView.boxed]
        items = GameSession.fetchAllInstances(in: GameManager.shared.cdStack.viewContext())
        items = items.sorted(by: {$0.finish! > $1.finish!})
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setupMenuItems() {
        topBarView.titleLabel.text = "Games History".ls
        topBarView.leftButton.setImage(UIImage.template("back"))
        topBarView.leftButton.contentEdgeInsets = .allX(8.0)
        topBarView.leftButton.onClick = { [unowned self] btn in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    override func updateSkin(_ skin: Skin) {
//        super.updateSkin(skin)
//    }
    
// MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (navigationController?.viewControllers.first as? GameSettingsViewController)?.startGame(with: items[indexPath.row])
    }
    
    
// MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HistoryTableViewCell.dequeue(tableView: tableView)
        let session = items[indexPath.row]
        guard let finish = session.finish else {return cell}
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.dateLabel.text = dateFormatter.string(from: finish)
        let playersString = (session.players.map{$0.name} as NSArray).componentsJoined(by: ", ")
        cell.backgroundColor = .clear
        cell.playersLabel.text = playersString
        cell.dateLabel.setSkinStyle(skin?.text)
        cell.playersLabel.setSkinStyle(skin?.h2)
        return cell
    }

}
