//
//  CDTableViewCell.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 19/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

protocol CDTableViewCellDelegate: class {
    func assetTapped(cdInfo: CDData?)
}

class CDTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cdImageResult: UIImageView!
    @IBOutlet weak var lblCD_Title: UILabel!
    @IBOutlet weak var lblCD_genre: UILabel!
    @IBOutlet weak var lblCD_year: UILabel!
    
    let cdMgr = DataManager()
    let formView = CDFormViewController()
    //var cd = CDData()
    
    weak var delegate: CDTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapRecognizer)
    }

    var cds : CDData?{
        didSet{
            setCDData()
        }
    }
    
    func cellTapped() {
        if let delegate = delegate {
            delegate.assetTapped(cdInfo: cds)
        }
    }
    
    func setCDData(){
 
        if let asset = cds{
            let genreArray = asset.genre
            let genre = genreArray.joined(separator: ", ")
        
            self.lblCD_Title.text = asset.title
            self.lblCD_genre.text = genre
            self.lblCD_year.text = asset.year
            self.cdImageResult.loadImageUsingCacheWithUrlString(urlString: asset.img_url)
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
