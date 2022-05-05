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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Claer DB
        //StorageManager.deleteAll()
        
        // выборка из БД + сортировка
        tasksLists = realm.objects(TaskList.self)
        
    }
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        allertForAddingList()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let taskList = tasksLists[indexPath.row]
        cell.textLabel?.text = taskList.name
        cell.detailTextLabel?.text = String(taskList.tasks.count)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? TasksTVC,
        let indexPath = tableView.indexPathForSelectedRow else { return }
        dvc.currentTasksList = tasksLists[indexPath.row]
    }
    
    private func allertForAddingList() {
        let title = "New list"
        let messege = "Plese insert new list name"
        let buttonTitle = "Save"
        
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let textField = alert.textFields?.first,
                      let name = textField.text else { return }
            
            let taskList = TaskList()
            taskList.name = name
            
            StorageManager.saveTaskList(taskList: taskList)
            
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "List name"
        }
        
        present(alert, animated: true)
    }
}
