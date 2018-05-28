//
//  Item.swift
//  Todo List
//
//  Created by Ali Furkan Budak on 28/05/2018.
//  Copyright © 2018 Ali Furkan Budak. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var checked : Bool = false
    @objc dynamic var date :Date?
    let category = LinkingObjects(fromType: Category.self, property: "items")
}
