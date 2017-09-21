//
//  OtherAssetsViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 10/09/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase

class OtherAssetsViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var assetImage: UIImageView!
    @IBOutlet weak var txtAssetName: UITextField!
    @IBOutlet weak var txtAssetYear: UITextField!
    @IBOutlet weak var txtAssetCategory: UITextField!
    @IBOutlet weak var txtAssetComments: UITextField!
    
    let saveButton = UIButton(type: .system)
    var selectedCat: String?

    
    let categories = CategoryViewController.categories
    
    let databaseRef = Database.database().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarItems()
        
        catPicker()
        createToolbar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func setUpNavigationBarItems(){
        
        navigationItem.title = "Other Assets"
        
        saveButton.setImage(#imageLiteral(resourceName: "icons8-Save Filled-50").withRenderingMode(.alwaysOriginal), for: .normal)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.addTarget(self, action: #selector(pressed(button:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    func pressed(button: UIButton!) {
        
        self.storeAsset(title: self.txtAssetName.text!, year: self.txtAssetYear.text!, category: self.txtAssetCategory.text!, comments: self.txtAssetComments.text! )
    }
    
    func storeAsset(title:String, year:String, category:String, comments:String){
        
        if self.txtAssetName.text != nil || self.txtAssetYear.text != nil || self.txtAssetCategory.text != nil || self.txtAssetComments.text != nil {
            
            let post: [String:Any] = ["title":title, "year": year, "category": category, "comments": comments]
            
            databaseRef.child("users").child((user?.uid)!).child(category).child(title).setValue(post)
            uploadImage(category: category)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }else{
            
            print("NOTE: Please do not leave it blank!")
        }
        
    }
    
    func uploadImage(category: String){
        
        if let imgData = UIImageJPEGRepresentation(self.assetImage.image!, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "img/jpeg"
            
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata) {(metadata, error) in
                if error != nil {
                    print("Did not upload image!")
                }else{
                    print("Image uploaded!")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        let data = ["userImg": url]
                        self.databaseRef.child("users").child((self.user?.uid)!).child(category).child(self.txtAssetName.text!).child("images").setValue(data)
                    }
                }
            }
        }
    }

    func catPicker(){
        let picker = UIPickerView()
        picker.delegate = self
        txtAssetCategory.inputView = picker
    }
    
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        toolbar.barTintColor = .orange
        toolbar.tintColor = .white
        
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([btnDone], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        txtAssetCategory.inputAccessoryView = toolbar
    }

}

extension OtherAssetsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCat = categories[row]
        txtAssetCategory.text = selectedCat
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
        }
        
        label.textColor = .orange
        label.textAlignment = .center
        
        label.text = categories[row]
        
        return label
    }
}

