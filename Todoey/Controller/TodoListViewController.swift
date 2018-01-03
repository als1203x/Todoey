//
//  ViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/28/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
   
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    let realm = try! Realm()
    
    var items : Results<Item>?
    
    var selectedCategory: Category? {
        didSet  {
            loadItems()
        }
    }
    
        //Access Core Data Persistent Container
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
  
    }

    //MARK - TableView DataSource MEthods
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            //check the done property to add checkmark
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    //MARK - TableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //Update Realm .. w/ write
        if let item = items?[indexPath.row] {
            do  {
                try realm.write {
                    item.done = !item.done
                }
            }catch  {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)  { (action) in
            //what will happen once the user clicks the "Add Item" button on UIAlert
        
            if textField.text != nil    {
                //Creating - Saving Realm
                
                if let currentCategory = self.selectedCategory  {
                        //Save Item
                    do  {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                                //
                            currentCategory.items.append(newItem)
                        }
                    }catch  {
                        print("Error saving new items, \(error)")
                    }
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField  { (alertTextField)  in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func loadItems()    {
 
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - SearchBar Extension
extension   TodoListViewController: UISearchBarDelegate {

    //MARK: - SearchBar Delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0   {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
