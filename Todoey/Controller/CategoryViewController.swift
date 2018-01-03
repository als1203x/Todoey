//
//  CategoryViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/30/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
            //Access Core Data Persistent Container
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatgories()
    
    }

    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let category = categories?[indexPath.row]    {
            
            cell.textLabel?.text = category.name
        
            guard let categoryColor = UIColor(hexString: category.color) else   {fatalError()}
                //cell  backgroundColor
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow    {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: Add New Category
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)  { (action) in
            //what will happen once the user clicks the "Add Item" button on UIAlert
            
            if textField.text != ""   {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                
                //Add category to persistence list
                self.saveCategory(category: newCategory)
            }
            self.tableView.reloadData()
        }
        alert.addTextField  { (alertTextField)  in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Data Manipulation Mthods
    
    func saveCategory(category: Category)    {
            //commit changes to realm database
        do  {
            try realm.write {
                realm.add(category)
            }
        }catch  {
            print("Error saving category: \(error)")
        }
    }
    
    func loadCatgories()    {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //Delete
    override func updateModel(at indexPath: IndexPath) {
        
        do  {
            try self.realm.write {
                self.realm.delete((self.categories?[indexPath.row])!)
            }
        }catch  {
            print("Error deleting category: \(error)")
        }
    }
}

