//
//  AddCategoryButton.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 14/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

class AddCategoryButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1/UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor.init(red: 0.96, green: 0.32, blue: 0.12, alpha: 1.0).cgColor

    }
}
