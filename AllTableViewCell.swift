//
//  AllTableViewCell.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 30/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase

protocol AllTableViewCellDelegate: class {
    func assetTapped(assetInfo: BooksFromFirebase?)
}

struct BooksFromFirebase {
    let title : String!
    let author : String!
    let publisher: String!
    let category: String!
    let type : String!
    let img_url: String!
    var index: Int?
}

struct CDsFromFirebase {
    let title : String!
    let genre : String!
    let country: String!
    let category: String!
    let img_url: String!
    var index: Int?
}

struct DVDsFromFirebase {
    let title : String!
    let year : String!
    let category: String!
    let img_url: String!
    var index: Int?
}


struct CategoryFromFirebase {
    let title : String!
    let defaultCat : String!
    let key : String!
}

class AllTableViewCell: UITableViewCell {

    //books
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var lblAssetName: UILabel!
    @IBOutlet weak var lblAssetType: UILabel!
    
    
    weak var delegate: AllTableViewCellDelegate!
    let detailView = DetailViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
       // self.addGestureRecognizer(tapRecognizer)
    }
    
    func cellTapped() {
        if let delegate = delegate {
            delegate.assetTapped(assetInfo: books)
        }
    }
    
    var books : BooksFromFirebase?{
        didSet{
            setAssetData()
        }
    }

    func setAssetData(){
        if let asset = books{
            self.lblAssetName.text = asset.title
            self.lblAssetType.text = asset.type
            self.assetImageView.loadImageUsingCacheWithUrlString(urlString: asset.img_url)
        }
    }
    
    var cds : CDsFromFirebase?{
        didSet{
            setCDData()
        }
    }
    
    func setCDData(){
        if let asset = cds{
            self.lblAssetName.text = asset.title
            self.lblAssetType.text = "CD"
            self.assetImageView.loadImageUsingCacheWithUrlString(urlString: asset.img_url)
        }
    }

    var dvds : DVDsFromFirebase?{
        didSet{
            setDVDData()
        }
    }
    
    func setDVDData(){
        if let asset = dvds{
            self.lblAssetName.text = asset.title
            self.lblAssetType.text = "DVD"
            self.assetImageView.loadImageUsingCacheWithUrlString(urlString: asset.img_url)
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
