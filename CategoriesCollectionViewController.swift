//
//  CategoriesCollectionViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 09/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoriesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    static var categories = ["Books", "CD"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return CategoriesCollectionViewController.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.nameLabel.text = CategoriesCollectionViewController.categories[indexPath.item]
    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! CategoryHeader
        header.viewController = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let allTableVC = self.storyboard?.instantiateViewController(withIdentifier: "AllTableViewController") as! AllTableViewController
        
        if indexPath.item == 0
        {
            allTableVC.isBook = true
        }
        else if indexPath.item == 1
        {
            allTableVC.isBook = false
        }
        
        allTableVC.isFromCategory = true
        
        self.navigationController?.pushViewController(allTableVC, animated: true)
    }
    
    func addNewCat(catName: String){
        CategoriesCollectionViewController.categories.append(catName)
        collectionView?.reloadData()
    }
}

//CLASS: CategoryCell inherits basecell class
class CategoryCell: BaseCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Category"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    override func setUpViews(){
     addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}

//CLASS: CategoryHeader inherits basecell class
class CategoryHeader: BaseCell {
    
    var viewController : CategoriesCollectionViewController?
    
    let catNameTextField: UITextField = {
    let textField = UITextField()
        textField.placeholder = "Enter a new category name..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setUpViews(){
        addSubview(catNameTextField)
        addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(CategoryHeader.addCategory), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": catNameTextField, "v1": addButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[v0]-24-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": catNameTextField]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": addButton]))
    }
    
    func addCategory(){
        viewController?.addNewCat(catName: catNameTextField.text!)
        catNameTextField.text = ""
    }
    
}

//CLASS: BaseCell is a parent class providing initialiser
class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){
    }
    
}


