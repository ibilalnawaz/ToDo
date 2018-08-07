//
//  TaskViewController.swift
//  TaskManagerRealm
//
//  Created by Bilal Nawaz on 7/23/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import RealmSwift
import FCAlertView

class TaskViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FCAlertViewDelegate {
    
    let realm = try! Realm()
    
    var task : Results<Task>?
    
    var taskName = ""
    
    var selectedCategory : Category?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTask: UIButton!
    @IBOutlet weak var editButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        editButton.layer.cornerRadius = 20
        
        tableView.rowHeight = 80.0
        loadData()
        
        searchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
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
    
    fileprivate func searchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Task"
        searchController.searchBar.tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TaskTableViewCell
        
        if let task = task?[indexPath.row]{
        cell.taskNameLabel.text = task.taskName
            
        let attributeString =  NSMutableAttributedString(string: "\(task.taskName)")

        if task.done == true{
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle,
                                         value: NSUnderlineStyle.styleSingle.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            cell.taskNameLabel.attributedText = attributeString
            cell.taskNameLabel.textColor = UIColor.gray
            cell.taskImage.image = UIImage(named: "task_done_true")
        }else{
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle,
                                         value: NSUnderlineStyle.styleNone.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            cell.taskNameLabel.attributedText = attributeString
            cell.taskNameLabel.textColor = UIColor.black
            cell.taskImage.image = UIImage(named: "task_done_false")
        }
        //cell.accessoryType = task.done ? .checkmark : .none
        }else{
            cell.taskNameLabel.text = "No Task Added Yet !"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = task?[indexPath.row]{
            do{
                try self.realm.write {
                    task.done = !task.done
                }
            }catch{
                print("error \(error)")
            }
            tableView.reloadData()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let selectedTask = task?[indexPath.row]{
                do{
                    try self.realm.write {
                        realm.delete(selectedTask)
                        tableView.reloadData()
                    }
                }catch{
                    print("error deleting task \(error)")
                }
                tableView.reloadData()
            }
        }
    }
    func loadData() {
        task = selectedCategory?.task.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    @IBAction func addTask(_ sender: UIButton) {
        let textField = UITextField()
        let addAlert = FCAlertView()
        addAlert.delegate = self
        addAlert.detachButtons = true
        addAlert.animateAlertInFromTop = true
        addAlert.dismissOnOutsideTouch = true
        addAlert.titleColor = UIColor(hexString: "900048")
        addAlert.tintColor = UIColor(hexString: "240041")
        
        addAlert.showAlert(withTitle: "Add Task", withSubtitle: "", withCustomImage: #imageLiteral(resourceName: "task_alert"), withDoneButtonTitle: "Add", andButtons: nil)
        
        addAlert.addTextField(withCustomTextField: textField,andPlaceholder:"New Task Name") { (text) in
            self.taskName = text!
        }
        
    }
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView){
        
        if taskName == ""{
            let showAlert = FCAlertView()
            showAlert.makeAlertTypeWarning()
            showAlert.showAlert(withTitle: "Required", withSubtitle: "Task name cannot be Empty.", withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
        }else{
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let taskData = Task()
                        taskData.taskName = taskName
                        taskData.done = false
                        taskData.dateCreated = Date()
                        currentCategory.task.append(taskData)
                    }
                }catch{
                    print("error saving task \(error)")
                }
            }
            self.tableView.reloadData()
        }
    }
}
extension TaskViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        task = task?.filter("taskName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    fileprivate func clearSearch(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        clearSearch(searchBar)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }
}
