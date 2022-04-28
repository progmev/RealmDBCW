//
//  TaskList.swift
//  RealmDBCW
//
//  Created by Martynov Evgeny on 28.04.22.
//

import Foundation
import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
