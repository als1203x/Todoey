//
//  Category.swift
//  Todoey
//
//  Created by LinuxPlus on 12/31/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object   {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    //relationships
        //forward
    let items = List<Item>() //empty list
    
}
