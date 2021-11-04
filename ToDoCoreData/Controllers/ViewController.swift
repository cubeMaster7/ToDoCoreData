//
//  ViewController.swift
//  ToDoCoreData
//
//  Created by Paul James on 27.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var todos = [ToDoList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ToDoListCoreData"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func getData() {
        
        do {
            todos = try context.fetch(ToDoList.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    @IBAction func activeMoveCells(_ sender: Any) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            addBarButton.isEnabled = false
        }
    }
    

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            context.delete(todo)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            let indexPath = tableView.indexPathForSelectedRow!
            let detailVC = segue.destination as? AddTaskViewController
            detailVC?.selectedIndex = todos[indexPath.row]
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "editTask", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editTask"{
//            let indexPath = tableView.indexPathForSelectedRow!
//            let detailVC = segue.destination as? AddTaskViewController
//            detailVC?.selectedIndex = todos[indexPath.row]
//        }
//    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos[sourceIndexPath.row]
        todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
//        делегаты для чекбокса
        cell.cellTaskDelegate = self
        cell.index = indexPath
        
        let todo = todos[indexPath.row]
        cell.configure(model: todo)
        return cell
    }
}

extension ViewController: PressReadyTaskButtonProtocols {
    func readyButtonTapped(indexPath: IndexPath) {
        let todo = todos[indexPath.row]
    
        updateReadyButtonTaskModel(task: todo, bool: !todo.isCompleted)
        
        tableView.reloadData()
    }
    
    func updateReadyButtonTaskModel(task: ToDoList, bool: Bool){
        task.isCompleted = bool
        do {
          try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
