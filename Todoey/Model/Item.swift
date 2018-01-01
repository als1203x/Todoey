//
//  Item.swift
//  Todoey
//
//  Created by LinuxPlus on 12/31/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object  {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
        //completes the inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
