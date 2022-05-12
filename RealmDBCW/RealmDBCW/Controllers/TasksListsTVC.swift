//
//  TasksListsTVC.swift
//  RealmDBCW
//
//  Created by Martynov Evgeny on 28.04.22.
//

import UIKit
import RealmSwift

class TasksListsTVC: UITableViewController {
    
    // Result - отображает данные в реальном времени
    var tasksLists: Results<TaskList>!
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Claer DB
        //StorageManager.deleteAll()
        
        // выборка из БД + сортировка
        tasksLists = realm.objects(TaskList.self)
        
        addTasksListsObserver()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        self.navigationItem.setRightBarButtonItems([addButton, editButtonItem], animated: true)
        
    }
    
    @IBAction func sortingSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    
    @objc private func addBarButtonSystemItemSelector() {
        allertForAddAndUpdatesListTasks() {
            print("Added new list")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let taskList = tasksLists[indexPath.row]
        cell.configure(with: taskList)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksLists[indexPath.row]
    
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(taskList: currentList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.allertForAddAndUpdatesListTasks(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneContextItem = UIContextualAction(style: .destructive, title: "All Done") { _, _, _ in
            StorageManager.makeAllDone(taskList: currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteContextItem.backgroundColor = .red
        editContextItem.backgroundColor = .orange
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem,
                                                                 editContextItem,
                                                                 doneContextItem])
        
        return swipeActions
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? TasksTVC,
        let indexPath = tableView.indexPathForSelectedRow else { return }
        dvc.currentTasksList = tasksLists[indexPath.row]
    }
    
    private func allertForAddAndUpdatesListTasks(_ tasksList: TaskList? = nil,
                                                 completion: @escaping () -> Void) {
        let title = tasksList == nil ? "New list" : "Edit list"
        let messege = "Plese insert list name"
        let buttonTitle = tasksList == nil ? "Save" : "Update"
        
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveUpdateAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            
            guard let newListName = alertTextField.text, !newListName.isEmpty else { return }
            
            if let tasksList = tasksList {
                StorageManager.editList(taskList: tasksList,
                                        newTaskListName: newListName)
                completion()
            } else {
                let taskList = TaskList()
                taskList.name = newListName
                StorageManager.saveTaskList(taskList: taskList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveUpdateAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            if let listName = tasksList {
                alertTextField.text = listName.name
            }
            textField.placeholder = "List name"
        }
        
        present(alert, animated: true)
    }
    
    private func addTasksListsObserver() {
        
        notificationToken = tasksLists.observe({ change in
            switch change {
                case .initial:
                    print("initial element")
                case .update(_, let deletions, let insertions, let modifications):
                    
                    print("deletions: \(deletions)")
                    print("insertions: \(insertions)")
                    print("modifications: \(modifications)")
                    
                    if !modifications.isEmpty {
                        var indexPathArray = [IndexPath]()
                        for row in modifications {
                            indexPathArray.append(IndexPath(row: row, section: 0))
                        }
                        self.tableView.reloadRows(at: indexPathArray, with: .automatic)
                    }
                    
                    // TODO: - deletions
                    
                    // TODO: - insertions
                    
                case .error(let error) :
                    print("error notification: \(error)")
            }
        })
        
    }
}
