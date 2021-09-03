//
//  Item.swift
//  Test App Santander
//
//  Created by Curitiba01 on 31/08/21.
//

import Foundation

class Meal: NSObject, NSCoding {
    var name: String
    var happiness: Int
    var items: [Item]
    
    init(name: String, happiness: Int, items: [Item] = []) {
        self.name = name
        self.happiness = happiness
        self.items = items
    }
    
    required init?(coder: NSCoder) {
        if let name = coder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else {
            self.name = ""
        }
        happiness = coder.decodeInteger(forKey: "happiness")
        if let items = coder.decodeObject(forKey: "items") as? [Item] {
            self.items = items
        } else {
            self.items = []
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(happiness, forKey: "happiness")
        coder.encode(items, forKey: "items")
    }
    
    func getItemsString() -> String {
        return items.reduce("", { result, item in
            return "\(result)\n\(item.name)"
        })
    }
}

class Item: NSObject, NSCoding {
    var name: String
    var cal: Double
    
    init(name: String, cal: Double) {
        self.name = name
        self.cal = cal
    }
    
    required init?(coder: NSCoder) {
        if let name = coder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else {
            self.name = ""
        }
        cal = coder.decodeDouble(forKey: "cal")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(cal, forKey: "cal")
    }
}
