//
//  CategoryViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/30/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    //Access Core Data Persistent Container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatgories()
        
    }

    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GOTOSender", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow    {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: Add New Category
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)  { (action) in
            //what will happen once the user clicks the "Add Item" button on UIAlert
            
            if textField.text != nil    {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                //Add list to persistence list
                self.saveCategories()
            }
        }
        alert.addTextField  { (alertTextField)  in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)    }
    
    
    //MARK: Data Manipulation Mthods
    
    func saveCategories()    {
        
        do  {
            try context.save()
        }catch  {
            print("Error saving category: \(error)")
        }
        //Reloads table with new data
        self.tableView.reloadData()
    }
    
    func loadCatgories()    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)
        }catch  {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
}
