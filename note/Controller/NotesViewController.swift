//
//  ViewController.swift
//  note
//
//  Created by IOS System on 8/3/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController : UITableViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    var selectedCategories : Category? {
        didSet {
            LoadData()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.text
        cell.accessoryType = item.done == true ? .checkmark : .none
        
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//      context.delete(itemArray[indexPath.row])
//      itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true )
        tableView.reloadData()
        saveContext()
    }
    
    
    
    @IBAction func Add(_ sender: Any) {
        
        var ItemTextFieled = UITextField()
        
        let alert = UIAlertController(title: "Add New Note", message: "" , preferredStyle: .alert)
        
        let Action = UIAlertAction(title: "Add", style: .default) { (action) in
            if ItemTextFieled.text != "" {
                let newItem = Notes(context: self.context)
                newItem.text = ItemTextFieled.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategories
                self.itemArray.append(newItem)
                self.saveContext()
                
                self.tableView.reloadData()
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel )
        
        
        alert.addTextField { (textFieled) in
            textFieled.placeholder = "Create New Note"
            ItemTextFieled = textFieled
            
        }
        
        alert.addAction(Action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func saveContext()  {
        do {
            try context.save()
        } catch  {
            print("Error Saving : \(error)")
        }
    }
    
    func LoadData(With request : NSFetchRequest<Notes> = Notes.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@" , (selectedCategories!.name)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate , categoryPredicate])
//
//        request.predicate = compoundPredicate
        
        do {
           itemArray = try context.fetch(request)
        } catch  {
            print("Error Fetching data from Context \(error)")
        }
        tableView.reloadData()
    }
}


//Mark: - Search Bar Method

extension NotesViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Notes> = Notes.fetchRequest()
        
          let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sorDescrepter = NSSortDescriptor(key: "text", ascending: true)
        request.sortDescriptors = [sorDescrepter]
        
        LoadData(With: request, predicate: predicate)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            LoadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

