//
//  UITableView+Common.swift
//  GameCountHelper
//
//  Created by Vlad on 5/14/20.
//  Copyright © 2020 Alexx. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func classReuseIdentifier() -> String {
        return  String(describing:self)
    }
    
    static func register(tableView:UITableView) {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: classReuseIdentifier())
    }
    
    static func dequeue(tableView:UITableView) -> Self {
        func helper<T>(tableView:UITableView) -> T where T : UITableViewCell {
            return tableView.dequeueReusableCell(withIdentifier: classReuseIdentifier()) as! T
        }
        return helper(tableView:tableView)
    }
}
