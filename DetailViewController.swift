//
//  DetailViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 14/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
     var bookInfo = [BooksFromFirebase]()
     var cdInfo = [CDsFromFirebase]()
    var strType : String!

    @IBOutlet weak var assetImage: UIImageView!
    @IBOutlet weak var lblAssetName: UILabel!
    @IBOutlet weak var lblAssetAuthor: UILabel!
    @IBOutlet weak var lblAssetComments: UILabel!
    @IBOutlet weak var lblAssetPublisher: UILabel!
    @IBOutlet weak var lblAssetCategory: UILabel!
    
    //@IBOutlet weak var categoryTextField: UITextField!
    
    var assetIndex: Int?
    var selectedCat: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        
        if let index = assetIndex {
            showInfo(numOfAssets: index)
        }
    }
    
    func showInfo(numOfAssets: Int){
        
        if strType == "CD"
        {
            guard numOfAssets >= 0 && numOfAssets < cdInfo.count else { return }
            
            let info = cdInfo[numOfAssets]
            self.assetImage.loadImageUsingCacheWithUrlString(urlString: info.img_url)
            self.lblAssetName.text = info.title
            self.lblAssetAuthor.text = ""
            self.lblAssetPublisher.text = ""
            self.lblAssetCategory.text = info.category
            self.lblAssetComments.text = ""
            
        }else{
            guard numOfAssets >= 0 && numOfAssets < bookInfo.count else { return }
            
            let info = bookInfo[numOfAssets]
            self.assetImage.loadImageUsingCacheWithUrlString(urlString: info.img_url)
            self.lblAssetName.text = info.title
            self.lblAssetAuthor.text = info.author
            self.lblAssetPublisher.text = info.publisher
            self.lblAssetCategory.text = info.category
        }
        
        
        
        
    }

    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
