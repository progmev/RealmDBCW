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
    
    // MARK: - TaskList methods
    
    static func saveTaskList(taskList: TaskList) {
        do {
            try realm.write {
                realm.add(taskList)
            }
        } catch {
            print("save error")
        }
    }
    
    static func deleteList(taskList: TaskList) {
        do {
            try realm.write {
                let tasks = taskList.tasks
                // последовательно удаляем tasks и taskList
                realm.delete(tasks)
                realm.delete(taskList)
            }
        } catch {
            print("delete error")
        }
    }
    
    static func editList(taskList: TaskList,
                         newTaskListName: String) {
        do {
            try realm.write {
                taskList.name = newTaskListName
            }
        } catch {
            print("edit error")
        }
    }
    
    static func makeAllDone(taskList: TaskList) {
        do {
            try realm.write {
                taskList.tasks.setValue(true, forKey: "isComplete")
            }
        } catch {
            print("makeAllDone error")
        }
    }
    
    // MARK: - Task methods
    
    static func saveNewTask(taskList: TaskList, task: Task) {
        do {
            try realm.write {
                taskList.tasks.append(task)
            }
        } catch {
            print("error saveNewTask")
        }
    }
    
    static func deleteTask(task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("delete task error")
        }
    }
    
    static func editTask(task: Task,
                         nameTask: String,
                         noteTask: String) {
        do {
            try realm.write {
                task.name = nameTask
                task.note = noteTask
            }
        } catch {
            print("edit task error")
        }
    }
    
    static func makeDone(task: Task) {
        do {
            try realm.write {
                task.isComplete.toggle()
            }
        } catch {
            print("make task done error")
        }
    }
}
