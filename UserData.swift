//
//  UserData.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 29/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import Foundation

class UserData{
    var username:String
    var userEmail:String
    var userImg:String
    
    init(name:String, email: String, image:String) {
        self.username = name
        self.userEmail = email
        self.userImg = image
    }
    
}
