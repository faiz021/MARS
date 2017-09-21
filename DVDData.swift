//
//  DVDData.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 20/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import Foundation

public class DVDData {
    
    static let sharedInstance = DVDData()
    
    var title: String
    var year: String
    var category: String
    var img_url: String
    var index: Int?
    
    init (){
        
        self.title = ""
        self.year = ""
        self.category = "DVD"
        self.img_url = ""

    }
    
}
