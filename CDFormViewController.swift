//
//  CDFormViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 19/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase

class CDFormViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cdDetailImageView: UIImageView!
    
    @IBOutlet weak var txtCD_title: UITextField!
    @IBOutlet weak var txtCD_genre: UITextField!
    @IBOutlet weak var txtCD_country: UITextField!
    @IBOutlet weak var txtCD_category: UITextField!
    @IBOutlet weak var txtCD_comment: UITextField!

    var cdIndex: Int?
    var cdInfo = [CDData]()
    let dataManager = DataManager()
    let saveButton = UIButton(type: .system)
    let assetForm = AssetFormViewController()
    
    let databaseRef = Database.database().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarItems()
        
        
        if let index = cdIndex {
            showInfo(numOfAssets: index)
        }

    }
    
    func showInfo(numOfAssets: Int){
        
        self.assetForm.startActivity()
        guard numOfAssets >= 0 && numOfAssets < cdInfo.count else { return }
        
        let info = cdInfo[numOfAssets]
        
        let genreArray = info.genre
        let genre = genreArray.joined(separator: ", ")
        
      
                self.cdDetailImageView.loadImageUsingCacheWithUrlString(urlString: info.img_url)
                self.txtCD_title.text = info.title
                self.txtCD_genre.text = genre
                self.txtCD_country.text = info.country
                self.txtCD_category.text = info.category
                self.txtCD_comment.placeholder = "Add text..."
                self.txtCD_comment.autocorrectionType = .no
                self.txtCD_comment.delegate = self
                self.assetForm.stopActivity()
        
    

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
        
        navigationItem.title = "CD Details"
        
        saveButton.setImage(#imageLiteral(resourceName: "icons8-Save Filled-50").withRenderingMode(.alwaysOriginal), for: .normal)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.addTarget(self, action: #selector(pressed(button:)), for: .touchUpInside)
        // self.view.addSubview(saveButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    func pressed(button: UIButton!) {
        
        self.storeCD(title: self.txtCD_title.text!, genre: self.txtCD_genre.text!, country: self.txtCD_country.text!, category: self.txtCD_category.text!,  comments: self.txtCD_comment.text! )
        // goToHomeVC()
    }
    
    func goToHomeVC(){
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    func storeCD(title:String, genre:String, country: String, category:String, comments:String){
        
        if self.txtCD_title.text != nil || self.txtCD_genre.text != nil || self.txtCD_country.text != nil || self.txtCD_category.text != nil {
            
            let post: [String:Any] = ["title":title, "genre": genre, "country": country, "category": category, "comments": comments]
            
            databaseRef.child("users").child((user?.uid)!).child(category).child(title).setValue(post)
            uploadImage(category: category)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }else{
            
            print("NOTE: Please do not leave it blank!")
        }
        
    }
    
    func uploadImage(category: String){
        

        if let imgData = UIImageJPEGRepresentation(self.cdDetailImageView.image!, 0.2){
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
                        self.databaseRef.child("users").child((self.user?.uid)!).child(category).child(self.txtCD_title.text!).child("images").setValue(data)
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
