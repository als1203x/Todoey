//
//  ViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/28/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
   
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        loadItems()
        
            //Load Data from UserDefaults
       // if let items = defaults.array(forKey:"TodoListArray") as? [Item] {
       //     itemArray = items
       // }
        
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
        
        saveItems()
        
        //breif highlight when selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)  { (action) in
            //what will happen once the user clicks the "Add Item" button on UIAlert
        
            if textField.text != nil    {
                self.itemArray.append(Item(title: textField.text!))
                //Add list to persistence list
                    //self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.saveItems()
            }
        }
        alert.addTextField  { (alertTextField)  in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems()    {
        let encoder = PropertyListEncoder()
        
        do  {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch  {
            print("Encoding error: \(error)")
        }
        //Reloads table with new data
        self.tableView.reloadData()
    }
    
    func loadItems()    {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do  {
            itemArray = try decoder.decode([Item].self, from: data)
            }catch  {
                print("Error decoding data \(error)")
            }
        }
    }
    
}
