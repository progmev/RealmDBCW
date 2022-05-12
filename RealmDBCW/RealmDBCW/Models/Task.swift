//
//  Task.swift
//  RealmDBCW
//
//  Created by Martynov Evgeny on 28.04.22.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
