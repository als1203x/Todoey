//
//  ViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/28/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard

    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item(title: "Find Meech")
        itemArray.append(newItem)
        
        
        if let items = defaults.array(forKey:"TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    //MARK - TableView DataSource MEthods
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
            //check the done property to add checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        //breif highlight when selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)  { (action) in
            //what will happen once the user clicks the "Add Item" button on UIAlert
        
            let newItem = Item(title: "Long")
      // let newItem = textField.text != nil ?  {
            //if textField.text != nil{
                self.itemArray.append(newItem)
                //Add list to persistence list
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                //Reloads table with new data
                self.tableView.reloadData()
            //}
        }
        alert.addTextField  { (alertTextField)  in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
