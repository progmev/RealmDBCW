//
//  UITableViewCellExt.swift
//  RealmDBCW
//
//  Created by Martynov Evgeny on 5.05.22.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TaskList) {
        
        let currentTasks = tasksList.tasks.filter("isComplete = false")
        let comletedTasks = tasksList.tasks.filter("isComplete = true")
        
        textLabel?.text = tasksList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = String(currentTasks.count)
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        } else if !comletedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 24)
            detailTextLabel?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
    }
}
