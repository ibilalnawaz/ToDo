//
//  Task.swift
//  TaskManagerRealm
//
//  Created by Bilal Nawaz on 7/21/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import Foundation
import RealmSwift

class Task : Object{
    
    @objc dynamic var taskName : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "task")
}
