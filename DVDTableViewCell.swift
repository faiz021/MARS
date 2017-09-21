//
//  DVDTableViewCell.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 20/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

protocol DVDTableViewCellDelegate: class {
    func assetTapped(dvdInfo: DVDData?)
}

class DVDTableViewCell: UITableViewCell {

    @IBOutlet weak var dvdImageResults: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieYear: UILabel!
    
    let dvdMgr = DataManager()
    let formView = DVDFormViewController()

    weak var delegate: DVDTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapRecognizer)

        // Initialization code
    }
    
    var dvds : DVDData?{
        didSet{
            setDVDData()
        }
    }
    
    func cellTapped() {
        if let delegate = delegate {
            delegate.assetTapped(dvdInfo: dvds)
        }
    }

    func setDVDData(){
        if let asset = dvds{
            self.lblMovieTitle.text = asset.title
            self.lblMovieYear.text = asset.year
            self.dvdImageResults.loadImageUsingCacheWithUrlString(urlString: asset.img_url)
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
