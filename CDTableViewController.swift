//
//  CDTableViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 19/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

class CDTableViewController: UITableViewController {
    
    var cd = [CDData]()
    let cdManager = DataManager()
    //let detailView = DetailViewController()
    var cdData: CDData?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CD BARCODE: ", CDData.sharedInstance.barcode)
        cdManager.requestCDData(barcode: CDData.sharedInstance.barcode){
            (data, success) in
            if success{
                self.cd = data as! [CDData]
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cdFormDetail" {
            if let detail = segue.destination as? CDFormViewController {
                detail.cdInfo = self.cd
                detail.cdIndex = cdData?.index
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
        return cd.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! CDTableViewCell
        cell.cds = cd[indexPath.row]
        cell.cds?.index = indexPath.row
        cell.delegate = self
        
        return cell

    }

   
}

extension CDTableViewController : CDTableViewCellDelegate {
    
    func assetTapped(cdInfo: CDData?) {
        self.cdData = cdInfo
        self.performSegue(withIdentifier: "cdFormDetail", sender: self)
    }
}
