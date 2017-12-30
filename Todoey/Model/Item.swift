//
//  Items.swift
//  Todoey
//
//  Created by LinuxPlus on 12/29/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import Foundation


class Item: Codable {
    
    var title: String
    var done: Bool
    
    init(title: String) {
        self.title = title
        done = false
    }
}
