//
//  ViewController.swift
//  Todo List
//
//  Created by Ali Furkan Budak on 20/05/2018.
//  Copyright © 2018 Ali Furkan Budak. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var list = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        let item = list[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.checked ? .checkmark : .none
    
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        list[indexPath.row].checked = !list[indexPath.row].checked
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addItem(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.checked = false
            item.category = self.selectedCategory
            
            self.list.append(item)
            self.saveItems()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveItems() {
        
        do { try context.save() }
        catch { print("Error while saving data \(error)") }
        self.tableView.reloadData()
    
    }
    
    func loadItems(Request request: NSFetchRequest<Item> = Item.fetchRequest(), Predicate predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        
        if let searchPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do { list = try context.fetch(request) }
        catch { print("Error while fetching data \(error)") }
        tableView.reloadData()
    
    }
}
//MARK: - Search Bar Methods
extension TableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0) {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }else{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(Request: request, Predicate: predicate)
        }
    }
}








