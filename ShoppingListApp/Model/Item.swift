//
//  Item.swift
//  ShoppingListApp
//
//  Created by Enes Kılıç on 19.09.2021.
//

import RealmSwift
import Foundation

class Item: Object {
    
    @objc dynamic var title: String = ""
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
