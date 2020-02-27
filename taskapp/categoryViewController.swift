//
//  categoryViewController.swift
//  taskapp
//
//  Created by Apple on 2020/02/16.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class categoryViewController: UIViewController {
    
    let realm = try! Realm()
    var categoryCC: CategoryClass!
    
    @IBOutlet weak var newCategoryField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
//    let testNow = "now"
    
    @IBAction func newCategory(_ sender: UIButton) {
        
        
        try! realm.write {
            
            self.categoryCC.pickCategory = self.newCategoryField.text!
            
           
            
            self.realm.add(self.categoryCC, update: .modified)
            
            
            
        }
         
         }

    
    
    
}

