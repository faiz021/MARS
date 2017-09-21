//
//  AllTableViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 30/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase

class AllTableViewController: UITableViewController {
    
    var categories = ["CD", "Books"]
    
    var bookPosts = [BooksFromFirebase]()
    var cdPosts = [CDsFromFirebase]()
    
    let detailView = DetailViewController()
    var assetInfo: BooksFromFirebase?
    var cdInfo: CDsFromFirebase?
    
    let user = Auth.auth().currentUser
    
    var isFromCategory : Bool = false
    var isBook : Bool = false
    
    var indexpathTodelete : IndexPath?

//    var indexArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.getDataFromFirebase()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if self.isFromCategory
        {
           if self.isBook
           {
              self.navigationItem.title = "Books"
            }
           else{
            self.navigationItem.title = "CD"
            }
        }
        
    }

    func getDataFromFirebase(){
        getBooks()
        getCDs()
    }
    
    func parseCategories()
    {
        
    }
    
    func getBooks()
    {
        Database.database().reference().child("users/\(user!.uid)/Books").observeSingleEvent(of: .value, with: {(Snapshot) in
            
            if let eachDict = Snapshot.value as? NSDictionary{
                print(eachDict)
                for each in eachDict{
                    //print((each.value as! NSDictionary)["title"] ?? "No data")
                    let assetTitle = (each.value as! NSDictionary)["title"] as? String ?? "No data"
                    let assetAuthor = (each.value as! NSDictionary)["author"] as? String ?? "No data"
                    let assetPublisher = (each.value as! NSDictionary)["publisher"] as? String ?? "No data"
                    let assetCategory = (each.value as! NSDictionary)["category"] as? String ?? "No data"
                    //print("Title 1: ",assetTitle)
                    let type = "Book"
                    //print("Type: ", type)
                    var url = ""
                    let info = each.value as! [String:Any]
                    //print("INFO: ", info)
                    if let images = info["images"] as? [String:Any] {
                        //print("IMAGES: ",images)
                        if let imgURL = images["userImg"] as? String{
                            url = imgURL
                        }
                    }
                    //print(info)
                    
                    self.bookPosts.insert(BooksFromFirebase(title: assetTitle, author: assetAuthor, publisher: assetPublisher, category: assetCategory, type: type, img_url: url, index: 0), at: 0)
                    
                    self.bookPosts = self.bookPosts.sorted(by: {$0.title < $1.title})
                    self.tableView.reloadData()
                    
                }

            }
            
            }, withCancel: {(Err) in
                
                print("Error: ",Err)
                // Handle error encountered while communicating with firebase
                
        })

    }
    
    func getCDs()
    {
        Database.database().reference().child("users/\(user!.uid)/CD").observeSingleEvent(of: .value, with: {(Snapshot) in
            
            if let eachDict = Snapshot.value as? NSDictionary{
                // print(eachDict)
                for each in eachDict{
                    //print((each.value as! NSDictionary)["title"] ?? "No data")
                    let assetTitle = (each.value as! NSDictionary)["title"] as? String ?? "No data"
                    let assetGenre = (each.value as! NSDictionary)["genre"] as? String ?? "No data"
                    let assetCountry = (each.value as! NSDictionary)["country"] as? String ?? "No data"
                    let assetCategory = (each.value as! NSDictionary)["category"] as? String ?? "No data"
                    //print("Type: ", type)
                    var url = ""
                    let info = each.value as! [String:Any]
                    //print("INFO: ", info)
                    if let images = info["images"] as? [String:Any] {
                        //print("IMAGES: ",images)
                        if let imgURL = images["userImg"] as? String{
                            url = imgURL
                        }
                    }
                    //print(info)
                    
                    self.cdPosts.insert(CDsFromFirebase(title: assetTitle, genre: assetGenre, country: assetCountry, category: assetCategory, img_url: url, index: 0), at: 0)
                    self.cdPosts = self.cdPosts.sorted(by: {$0.title < $1.title})
                    self.tableView.reloadData()
                    
                }
//                self.cdPosts = self.cdPosts.sorted(by: {$0.title < $1.title})
//                self.tableView.reloadData()
            }
            
            }, withCancel: {(Err) in
                
                print("Error: ",Err)
                // Handle error encountered while communicating with firebase
                
        })

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if self.isFromCategory{
            
            return 1
        }
        else{
            return 2
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.isFromCategory{
            
            if self.isBook{
                
                 return bookPosts.count
            }
            else{
                return  cdPosts.count
            }
        }
        else {
            if section == 0
            {
                return  cdPosts.count
            }
            else {
                return bookPosts.count
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetsCell", for: indexPath) as! AllTableViewCell
        
        if isFromCategory{
            
            if self.isBook
            {
                
                cell.books = bookPosts[indexPath.row]
                cell.books?.index = indexPath.row

            }
            else{
                
                cell.cds = cdPosts[indexPath.row]
                cell.cds?.index = indexPath.row
            }
        }
        else{
            if indexPath.section == 0
            {
                cell.cds = cdPosts[indexPath.row]
                cell.cds?.index = indexPath.row
                
            }
            else{
                
                cell.books = bookPosts[indexPath.row]
                cell.books?.index = indexPath.row
            }
        }
        
        
       // cell.delegate = self
        
        return cell
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return indexArray
//    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        if self.isFromCategory{
            
            if self.isBook{
                
                detailVC.bookInfo = self.bookPosts
                detailVC.assetIndex = indexPath.row
                detailVC.strType = "Book"
            }
            else{
                
                detailVC.cdInfo = self.cdPosts
                detailVC.assetIndex = indexPath.row
                detailVC.strType = "CD"
            }
            
        }else{
            
            if indexPath.section == 0
            {
                detailVC.cdInfo = self.cdPosts
                detailVC.assetIndex = indexPath.row
                detailVC.strType = "CD"
                
            }
            else{
                detailVC.bookInfo = self.bookPosts
                detailVC.assetIndex = indexPath.row
                detailVC.strType = "Book"
            }

        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            print("Cell Delete")
            self.indexpathTodelete = indexPath
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
        if isFromCategory{
            
            if self.isBook
            {
                let books = bookPosts[(indexpathTodelete?.row)!]
                print("Book to delete \(books)")
                Database.database().reference().child("users/\(user!.uid)/Books").child(books.title).removeValue()
                self.bookPosts.remove(at: (indexpathTodelete?.row)!)
                self.tableView.deleteRows(at: [indexpathTodelete!], with: .fade)
            }
            else {
                let cds = cdPosts[(indexpathTodelete?.row)!]
                print("CD to delete \(cds)")
                Database.database().reference().child("users/\(user!.uid)/Books").child(cds.title).removeValue()
                self.cdPosts.remove(at: (indexpathTodelete?.row)!)
                self.tableView.deleteRows(at: [indexpathTodelete!], with: .fade)
            }
        }
        else {
            if indexpathTodelete?.section == 0
            {
                let cds = cdPosts[(indexpathTodelete?.row)!]
                print("CD to delete \(cds)")
                Database.database().reference().child("users/\(user!.uid)/Books").child(cds.title).removeValue()
                self.cdPosts.remove(at: (indexpathTodelete?.row)!)
                self.tableView.deleteRows(at: [indexpathTodelete!], with: .fade)
            }
            else {
                let books = bookPosts[(indexpathTodelete?.row)!]
                print("Book to delete \(books)")
                Database.database().reference().child("users/\(user!.uid)/Books").child(books.title).removeValue()
                self.bookPosts.remove(at: (indexpathTodelete?.row)!)
                self.tableView.deleteRows(at: [indexpathTodelete!], with: .fade)
            }
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail" {
            if let detail = segue.destination as? DetailViewController {
                
                detail.bookInfo = self.bookPosts
                detail.assetIndex = assetInfo?.index
            }
        }

    }
 */

}

extension AllTableViewController : AllTableViewCellDelegate {
    
    func assetTapped(assetInfo: BooksFromFirebase?) {
       // self.assetInfo = assetInfo
       // self.performSegue(withIdentifier: "ToDetail", sender: self)
    }
}

