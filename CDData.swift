//
//  CDData.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 19/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import Foundation

public class CDData {
    
    static let sharedInstance = CDData()
    
    var title: String
    var genre: [String]
    var country: String
    var category: String
    var year: String
    var img_url: String
    var barcode: String
    var index: Int?
    
    init (){
        
        self.title = ""
        self.genre = [""]
        self.country = ""
        self.category = "CD"
        self.year = ""
        self.img_url = ""
        self.barcode = ""
    }
    
}
