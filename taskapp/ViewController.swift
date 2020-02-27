//
//  ViewController.swift
//  taskapp
//
//  Created by Apple on 2020/02/05.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
   
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var listPickerView: UIPickerView!
    
    let realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       listPickerView.delegate = self
       listPickerView.dataSource = self
        
        
        
        }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let inputViewController:InputViewController = segue.destination as! InputViewController

        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            
        } else {
            let task = Task()
           
            let allTasks = realm.objects(Task.self)
           
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            
            inputViewController.task = task
        }
        
        
        
}
    
   @IBAction func searchButton(_ sender: UIButton) {
        taskArray = try! Realm().objects(Task.self).filter("categoryT = '" + searchTextField.text! + "'").sorted(byKeyPath: "date", ascending: true)
 
    tableView.reloadData()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
       
    }
    
    
//    セルの個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
       }

       // 各セルの内容を返すメソッド
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // 再利用可能な cell を得る
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD HH:mm"

        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
       }

       // 各セルを選択した時に実行されるメソッド
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
       }

       // セルが削除が可能なことを伝えるメソッド
       func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .delete
       }

       // Delete ボタンが押された時に呼ばれるメソッド
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
       }

//    pickerView
     var categoryArray = try! Realm().objects(CategoryClass.self)
       let category = CategoryClass()
              
         
             // pickerの列の数
             func numberOfComponents(in pickerView: UIPickerView) -> Int {
                 return 1
             }
             
             // pickerに表示する値の数
             func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
              
                print(categoryArray.count)
               return categoryArray.count
               
               
             }
             
             
              //pickerに表示する値を返すデリゲートメソッド.
             func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                 
              let category = categoryArray[row]
              return category.pickCategory
              
       }
             
             
             // pickerが選択された際に呼ばれるデリゲートメソッド.
             func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
               
               let category = categoryArray[row]
            searchTextField.text = category.pickCategory
               
             }
    }


