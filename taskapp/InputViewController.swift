//
//  inputViewController.swift
//  taskapp
//
//  Created by Apple on 2020/02/05.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications


class InputViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
   
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTxtView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var MyPicker: UIPickerView!
    
    
    
    
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        キーボードをしまう
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
//        入力パーツ
        titleTextField.text = task.title
        contentsTxtView.text = task.contents
        datePicker.date = task.date
        categoryLabel.text = task.categoryT
        
       
//        pickerView
        
       MyPicker.delegate = self
       MyPicker.dataSource = self
        
         
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        MyPicker.reloadAllComponents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTxtView.text
            self.task.date = self.datePicker.date
            self.task.categoryT = self.categoryLabel.text!
           
            
            self.realm.add(self.task, update: .modified)
            
            
        }
        
        setNotification(task: task)
        super.viewWillDisappear(animated)
    }
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        
        content.sound = UNNotificationSound.default
        
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error)in
            print(error ?? "ローカル通知登録　OK")
        }
        
        center.getPendingNotificationRequests {
            (requests: [UNNotificationRequest])  in
            for request in requests {
                print("/----------------")
                print(request)
                print("-----------------/")
            }
        }
    }
    
    
    @objc func dismissKeyboard() {
        
//        キーボードを閉じる
        view.endEditing(true)
    }
    
    

    var categoryArray = try! Realm().objects(CategoryClass.self)
    let category = CategoryClass()
           
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let CategoryViewController:categoryViewController = segue.destination as! categoryViewController
        
        let categoryA = CategoryClass()
                     let allCategory = realm.objects(CategoryClass.self)
                     if allCategory.count != 0 {
                        categoryA.id = allCategory.max(ofProperty: "id")! + 1
            }
        
        CategoryViewController.categoryCC = categoryA
    }
   
          // pickerの列の数
          func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
          }
          
          // pickerに表示する値の数
          func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           
            
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
           categoryLabel.text = category.pickCategory
            
          }
    
   
    

   
}
