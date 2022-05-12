//
//  TasksTVC.swift
//  RealmDBCW
//
//  Created by Martynov Evgeny on 28.04.22.
//

import UIKit
import RealmSwift

class TasksTVC: UITableViewController {
    
    var currentTasksList: TaskList!
    
    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
        
        filteringTasks()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        self.navigationItem.setRightBarButtonItems([addButton, editButtonItem], animated: true)
    }
    
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdateTask()
    }

    private func alertForAddAndUpdateTask(_ task: Task? = nil) {
        
        let title = "New task"
        let messege = task == nil ? "Plese insert new task name" : "Plese edit task name"
        let buttonTitle = task == nil ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var nameTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            
            guard let nameTask = nameTextField.text, !nameTask.isEmpty,
                  let noteTask = noteTextField.text, !noteTask.isEmpty else { return }
            
            if let task = task {
                StorageManager.editTask(task: task, nameTask: nameTask, noteTask: noteTask)
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = nameTask
                task.note = noteTask
                StorageManager.saveNewTask(taskList: self.currentTasksList, task: task)
                self.filteringTasks()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            nameTextField = textField
            nameTextField.placeholder = "Task name"
            if let task = task {
                nameTextField.text = task.name
            }
        }
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Task note"
            if let task = task {
                noteTextField.text = task.note
            }
        }
        present(alert, animated: true)
    }
    
    
    private func filteringTasks() {
        notCompletedTasks = currentTasksList.tasks.filter("isComplete = false")
        completedTasks = currentTasksList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompletedTasks.count : completedTasks.count
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "In progress tasks" : "Comleted tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]

        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task: task)
            self.filteringTasks()
        }

        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateTask(task)
        }

        let doneText = task.isComplete ? "Not done" : "Done"
        let doneContextItem = UIContextualAction(style: .destructive, title: doneText) { _, _, _ in
            StorageManager.makeDone(task: task)
            self.filteringTasks()
        }

        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])

        return swipeActions
    }
}
