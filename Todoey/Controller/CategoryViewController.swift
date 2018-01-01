//
//  CategoryViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/30/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GOTOSender", sender: self)
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
            
            if textField.text != nil    {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                //Add list to persistence list
                self.saveCategory(category: newCategory)
            }
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
        
        do  {
            try realm.write {
                realm.add(category)
            }
        }catch  {
            print("Error saving category: \(error)")
        }
        //Reloads table with new data
            //self.tableView.reloadData()  -- CoreData
    }
    
    func loadCatgories()    {
      /*      let request : NSFetchRequest<Category> = Category.fetchRequest()
            do{
                try realm.
                //categoryArray = try context.fetch(request)
            }catch  {
                print("Error fetching data: \(error)")
            }
             */
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
