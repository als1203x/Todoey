//
//  ViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 12/28/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var items : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet  {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else   { fatalError()  }
        
        title = selectedCategory?.name
        updateNavBar(withHexCode: colorHex)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    func updateNavBar(withHexCode colorHexCode: String)    {
        // you can never be sure when VC is put into the navigation Controller; viewWillAppear
        guard let navBar = navigationController?.navigationBar else { fatalError("Naviagtion controller does not exist.")}
    
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()  }
        //color text of naviagitonBar- large text
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        //color of navigation UI
        navBar.barTintColor = navBarColor
        //color of all navigation items & barButtons
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        searchBar.barTintColor = navBarColor
    }
    

    //MARK - TableView DataSource MEthods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //if let color =
            cell.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text =  "No Items Added Yet"
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
        
            if textField.text != ""    {
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
    
    //Deleting
    
    override func updateModel(at indexPath: IndexPath) {
        do{
            try realm.write {
                realm.delete((items?[indexPath.row])!)
            }
        }catch  {
            print("Error deleting item: \(error)")
        }
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
