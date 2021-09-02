//
//  Item.swift
//  Test App Santander
//
//  Created by Curitiba01 on 31/08/21.
//

import Foundation

struct Meal {
    var name: String
    var happiness: Int
    var items: [Item]
    
    init(name: String, happiness: Int, items: [Item] = []) {
        self.name = name
        self.happiness = happiness
        self.items = items
    }
}

struct Item {
    var name: String
    var cal: Double
}
