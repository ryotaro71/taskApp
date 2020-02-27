//
//  categoryC.swift
//  taskapp
//
//  Created by Apple on 2020/02/17.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import RealmSwift

class CategoryClass: Object {
   
    @ objc dynamic var id = 0
    
    @objc dynamic var pickCategory = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
