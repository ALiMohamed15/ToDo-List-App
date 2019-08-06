//
//  CategoryViewController.swift
//  note
//
//  Created by IOS System on 8/6/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: indexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotesViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategories = categoryArray[indexPath.row]
        }
    }
    
    
    
    
    @IBAction func CategoryAddButtonPressed(_ sender: Any) {
        var CategoryTextField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New To Do List", message: "", preferredStyle: .alert)
        let Action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            let list = Category(context: self.context)
            
            list.name = CategoryTextField.text
            
            self.categoryArray.append(list)
            self.saveContext()
            self.tableView.reloadData()
            
            }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New List"
            CategoryTextField = textField
            
        }
        alert.addAction(Action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch  {
            print("Error Saving Category \(error)")
        }
        
    }
    func loadData(With request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
           categoryArray = try context.fetch(request)
        } catch  {
            print("Error Fetching data from Context \(error)")
        }
        tableView.reloadData()
    }
    
}
