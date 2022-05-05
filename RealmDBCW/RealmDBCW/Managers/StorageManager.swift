//
//  StorageManager.swift
//  RealmDBCW
//
//  Created by Martynov Evgeny on 28.04.22.
//

import Foundation
import RealmSwift

let realm = try! Realm()

// MARK: - StorageManager

class StorageManager {
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    static func saveTaskList(taskList: TaskList) {
        do {
            try realm.write {
                realm.add(taskList)
            }
        } catch {
            print("error deleteAll")
        }
    }
    
    
    static func saveNewTask(taskList: TaskList, task: Task) {
        do {
            try realm.write {
                taskList.tasks.append(task)
            }
        } catch {
            print("error saveNewTask")
        }
    }
}
