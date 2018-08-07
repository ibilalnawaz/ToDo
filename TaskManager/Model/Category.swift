//
//  Category.swift
//  TaskManagerRealm
//
//  Created by Bilal Nawaz on 7/21/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let task = List<Task>()
}
