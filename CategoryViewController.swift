//
//  CategoryViewController.swift
//  MARS
//
//  Created by Agam on 08/09/17.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryArray = [CategoryFromFirebase]()
    static var categories: [String] = []
    var indexTodelete = -1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCategories()

        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
        if categoryTF.text != ""
        {
            self.saveCategory()
        }
    }
    
    //MARK: Firebase
    
    func getCategories()
    {
        Database.database().reference().child("Category").observeSingleEvent(of: .value, with: {(Snapshot) in
            self.categoryArray.removeAll()
            if let eachDict = Snapshot.value as? NSDictionary{
                //print("Category \(eachDict)")
                for each in eachDict{
                    let assetTitle = (each.value as! NSDictionary)["title"] as? String ?? "No data"
                    let assetType = (each.value as! NSDictionary)["default"] as? String ?? "0"
                    let assetKey = each.key as! String
                    
                    
                    self.categoryArray.append(CategoryFromFirebase(title: assetTitle, defaultCat: assetType, key: assetKey))
                
                }
                self.categoryArray = self.categoryArray.sorted(by: {$0.title < $1.title})
                self.tableView.reloadData()
                for cat in self.categoryArray {
                    CategoryViewController.categories.append(cat.title)
                    print("CATS: ", cat.title)
                }
                
            }
            else
            {
                //                if self.categoryArray.count == 0
                //                {
                //                    self.saveDefaultCategory()
                //                }
            }
            
            }, withCancel: {(Err) in
                
                print("Error: ",Err)
                // Handle error encountered while communicating with firebase
                
        })
        
    }
    
    
    func saveCategory()
    {
        let cat = self.categoryTF.text!
        let post: [String:Any] = ["title": cat, "default" : "0"]
        
        Database.database().reference().child("Category").childByAutoId().setValue(post)
        self.categoryTF.text = ""
        self.getCategories()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let dict = categoryArray[indexPath.row]
        //print("DICT: ", dict.title)
        //for cat in categoryArray {
           // CategoryViewController.categories.append(dict.title)
           // print("CATS: ", dict.title)
        //}

        
        cell.textLabel?.text = dict.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let dict = categoryArray[indexPath.row]
   
        if dict.defaultCat == "0"
        {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            print("Cell Delete")
            self.indexTodelete = indexPath.row
            showDeleteAlert()
        }
    }
    
    
    //MARK: Delete Methods
    
    func showDeleteAlert() {
        let alertview = UIAlertController(title: "Delete", message: "Are you sure to delete?", preferredStyle: UIAlertControllerStyle.actionSheet)
        alertview.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            print("Cancel")
            self.tableView.reloadData()
        }))
        alertview.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertActionStyle.destructive, handler: { action in
            print("Delete")
            self.deleteDataFromFirebase()
        }))
        self.present(alertview, animated: true, completion: nil)
    }
    
    func deleteDataFromFirebase()
    {
        let cat = categoryArray[indexTodelete]
        print("Book to delete \(cat)")
        Database.database().reference().child("Category").child(cat.key).removeValue()
        self.categoryArray.remove(at: indexTodelete)
        self.tableView.reloadData()
    }
}
