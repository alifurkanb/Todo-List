//
//  Category.swift
//  Todo List
//
//  Created by Ali Furkan Budak on 28/05/2018.
//  Copyright © 2018 Ali Furkan Budak. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
