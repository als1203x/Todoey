//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by LinuxPlus on 1/2/18.
//  Copyright © 2018 ARC. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
       
        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: Swipe Cell Delegate Methods

        //Action upon swipe
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            //Action for what happens once swiped in orientation direction
            guard orientation == .right else {  return nil    }
            
          let deleteAction = SwipeAction(style: .destructive, title: "Delete")
            {   action, indexPath in
                // handle action by updating model with deletion
               
                self.updateModel(at: indexPath)
                
            }
            
            //  customize the action apperence
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
        }
 
        //Full Swipe to delete
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    func updateModel(at indexPath: IndexPath)   {
        //Update our data model
    }
    
}