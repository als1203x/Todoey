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
    
    
    
    var itemArray = [Item]()
    
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
        //Update item - then save context
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
     
        
            //DeletingItem
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //breif highlight when selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)  { (action) in
            //what will happen once the user clicks the "Add Item" button on UIAlert
        
            if textField.text != nil    {
              
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
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
    
    //MARK: - Model Manupulation Methods
    
    func saveItems()    {
      
        do  {
            try context.save()
        }catch  {
            print("Error saving item: \(error)")
        }
        //Reloads table with new data
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)    {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //allows for the use of multiple predicates
        if let addtionalPredicate = predicate   {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch  {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - SearchBar Extension
extension   TodoListViewController: UISearchBarDelegate {

    //MARK: - SearchBar Delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Query the database
        let request: NSFetchRequest<Item> = Item.fetchRequest()
            // format -- title = attribute in data to search, that CONTAINS, %@ is the args, which is replaced by the 2nd param
            //Predicate specifics how data should be fetched -- using logical conditions
            //add [c],[d], or [cd] after condition to ignore case, diacritic, or both
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // sort return data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

       loadItems(with: request, predicate: predicate)
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
