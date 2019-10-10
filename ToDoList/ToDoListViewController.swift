//
//  ToDoListViewController.swift
//  ToDoList
//
/*
 MIT License
 
 Copyright (c) 2018 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

protocol ToDoListDelegate: class {
    func update(item: ToDoItemModel, index: Int)
    func add(name: String, details: String, completionDate: Date)
}

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ToDoListDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems: [ToDoItemModel] = [ToDoItemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTouch))
        
        title = "To Do List"
        let test = ToDoItemModel(name: "Run", details: "Go for a run in the park", completionDate: Date())
        toDoItems.append(test)
        
        let test2 = ToDoItemModel(name: "Create presentation", details: "Create a presentation", completionDate: Date())
        toDoItems.append(test2)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = toDoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath)
        cell.textLabel?.text = toDoItem.name
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDoItem = toDoItems[indexPath.row]
        let toDoTuple = (indexPath.row, toDoItem)
        performSegue(withIdentifier: "ToDoDetailsSegue", sender: toDoTuple)
    }
    
    @objc func addButtonDidTouch(){
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToDoDetailsSegue"){
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else { return }
            guard let toDoTuple = sender as? (Int, ToDoItemModel) else { return }
            destinationVC.toDoIndex = toDoTuple.0
            destinationVC.toDoItem = toDoTuple.1
            destinationVC.delegate = self
        }
        if(segue.identifier == "AddTaskSegue"){
            guard let destinationVC = segue.destination as? AddTaskViewController else { return }
            destinationVC.delegate = self
        }
    }
    
    func update(item: ToDoItemModel, index: Int) {
        toDoItems[index] = item
        tableView.reloadData()
    }
    
    func add(name: String, details: String, completionDate: Date) {
        let toDoItem = ToDoItemModel(name: name, details: details, completionDate: completionDate)
        toDoItems.append(toDoItem)
        tableView.reloadData()
    }

}
