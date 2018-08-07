//
//  CategoriesViewController.swift
//  TaskManagerRealm
//
//  Created by Bilal Nawaz on 7/23/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import FCAlertView
import ChameleonFramework
import RealmSwift

class CategoriesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FCAlertViewDelegate {
    
    let realm = try! Realm()
    var category : Results<Category>?
    var categoryName : String  = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ifEmptyLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ifEmptyLabel.isHidden = true
        tableView.rowHeight = 80.0
        
        addButton.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        addButton.layer.cornerRadius = addButton.frame.width / 2
        
        editButton.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        editButton.layer.cornerRadius = 20
        
        self.becomeFirstResponder()
        
        loadDataForCategories()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadDataForCategories()
    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AddCategoryAlert()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! categoryTableViewCell
        if let categoryName = category?[indexPath.row]{
            cell.categoryNameLabel.text = categoryName.name
            cell.categoryCountLabel.text = "\(categoryName.task.count) Tasks"
        }else{
            cell.categoryNameLabel.text = "No Categories Added!"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let selectedCategory = category?[indexPath.row]{
                do{
                    try self.realm.write {
                        realm.delete(selectedCategory)
                        tableView.reloadData()
                    }
                }catch{
                    print("error deleting task \(error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    
    @IBAction func editTask(_ sender: UIButton) {
        
        if tableView.isEditing == true {
            self.tableView.setEditing(false, animated: true)
            editButton.setTitle("Edit", for: .normal)
            editButton.frame = CGRect(x: 0, y: 0, width: 80, height: 40)

        }
        else
        {
            self.tableView.setEditing(true, animated: true)
            editButton.setTitle("Cancel", for: .normal)
            editButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        }
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
        AddCategoryAlert()
    }
    fileprivate func AddCategoryAlert() {
        let textField = UITextField()
        let addAlert = FCAlertView()
        addAlert.delegate = self
        addAlert.animateAlertInFromBottom = true
        addAlert.dismissOnOutsideTouch = true
        addAlert.titleColor = UIColor(hexString: "900048")
        addAlert.tintColor = UIColor(hexString: "240041")
        addAlert.detachButtons = true
        addAlert.showAlert(withTitle: "Add Category", withSubtitle: "", withCustomImage: #imageLiteral(resourceName: "categoryList_alert"), withDoneButtonTitle: "Add", andButtons: nil)
        
        addAlert.addTextField(withCustomTextField: textField, andPlaceholder: "New Category Name") { (text) in
            self.categoryName = text!
            
        }
    }
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView){
        
        if categoryName == ""{
            let showAlert = FCAlertView()
            showAlert.makeAlertTypeWarning()
            showAlert.showAlert(withTitle: "Required", withSubtitle: "Category name cannot be Empty.", withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
        }else{
            let categoryData = Category()
            categoryData.name = categoryName
            self.saveData(category: categoryData)
        }
        
    }
    func saveData(category : Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Saving Task \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadDataForCategories(){
        category = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
}
