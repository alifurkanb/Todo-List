//
//  ViewController.swift
//  Todo List
//
//  Created by Ali Furkan Budak on 20/05/2018.
//  Copyright © 2018 Ali Furkan Budak. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    let realm = try! Realm()
    var list : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        
        if let item = list?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = list?[indexPath.row]{
            do{
                try realm.write {
                    item.checked = !item.checked
                }
            }catch{
                print("Error while updating data \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addItem(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                    let item = Item()
                    item.title = textField.text!
                    item.date = Date()
                    currentCategory.items.append(item)
                }
                }catch{
                    print("Error while adding new item \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadItems() {
        list = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    
    }
}
//MARK: - Search Bar Methods
extension TableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0) {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }else{
            list = list?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
        }
    }
}








