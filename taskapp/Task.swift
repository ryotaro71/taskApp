//
//  Task.swift
//  taskapp
//
//  Created by Apple on 2020/02/09.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var categoryT = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}



