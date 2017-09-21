//
//  DVDTableViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 20/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

class DVDTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataManager = DataManager()
    var dvd = [DVDData]()
    var dvdData: DVDData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.requestDVDData(name: DVDData.sharedInstance.title){
            (data, success) in
            if success{
                self.dvd = data as! [DVDData]
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dvdForm" {
            if let detail = segue.destination as? DVDFormViewController {
                detail.dvdInfo = self.dvd
                detail.dvdIndex = dvdData?.index
            }
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        let finalKeyword = keyword?.replacingOccurrences(of: " ", with: "%")
        dataManager.requestDVDData(name: finalKeyword!){
            (data, success) in
            if success{
                self.dvd = data as! [DVDData]
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dvd.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dvdCell", for: indexPath) as! DVDTableViewCell
        print(dvd)
        
        cell.dvds = dvd[indexPath.row]
        cell.dvds?.index = indexPath.row
        cell.delegate = self
        
        return cell
        
    }
    
}

extension DVDTableViewController : DVDTableViewCellDelegate {
    
    func assetTapped(dvdInfo: DVDData?) {
        self.dvdData = dvdInfo
        self.performSegue(withIdentifier: "dvdForm", sender: self)
    }
}
