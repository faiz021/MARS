//
//  Books.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 23/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import Foundation

public class Books {
    
    static let sharedInstance = Books()
    
    var title: String
    var publisher: String
    var author: String
    var category: String
    

   init (){
    
        self.title = ""
        self.publisher = ""
        self.author = ""
        self.category = "Books"
    }
    
   }
