//
//  AssetFormViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 01/08/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase

class AssetFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var lastTextConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UITextField!
    @IBOutlet weak var lblAuthor: UITextField!
    @IBOutlet weak var lblPublisher: UITextField!
    @IBOutlet weak var lblCategory: UITextField!
    @IBOutlet weak var lblComment: UITextField!
    @IBOutlet weak var bookImagePicker: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    let saveButton = UIButton(type: .system)
    var imgPicker: UIImagePickerController!
    var imageSelected = false
    var selectedCat: String?
    let categories = CategoriesCollectionViewController.categories
    
    var book = [Books]()
    let dataManager = DataManager()
    let databaseRef = Database.database().reference()
    let user = Auth.auth().currentUser
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    
//    
//    func keyboardWillShow(notification: NSNotification){
//        if let info = notification.userInfo{
//            
//            let rect = (info["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
//            //let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
//            
//            self.view.layoutIfNeeded()
//            
//            UIView.animate(withDuration: 0.25, animations: {
//                
//                self.view.layoutIfNeeded()
//                self.lastTextConstraint.constant = rect.height+20
//            })
//        }
//    }
//    
    
    override func viewWillAppear(_ animated: Bool) {
        catPicker()
        createToolbar()
        
        
        self.perform(#selector(setData), with: nil, afterDelay: 0.5)
        
        imgPicker = UIImagePickerController()
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        
        
        setUpNavigationBarItems()
    }
    
    func setData()
    {
        self.startActivity()
        dataManager.requestBookData(isbn: CDData.sharedInstance.barcode, completion: { (data, success) in
            if(success){
                
                self.book = data as! [Books]
                self.lblTitle.text = Books.sharedInstance.title
                self.lblAuthor.text = Books.sharedInstance.author
                self.lblPublisher.text = Books.sharedInstance.publisher
                self.lblCategory.text = Books.sharedInstance.category
                self.lblComment.text = "Add texts here..."
                self.lblComment.delegate = self
                self.stopActivity()
            }
            
            print("VC INDEX: ", HomeViewController.btn_index)
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func startActivity(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivity(){
        activityIndicator.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    private func setUpNavigationBarItems(){
        
        self.navigationItem.title = "Asset Form"
        
        saveButton.setImage(#imageLiteral(resourceName: "icons8-Save Filled-50").withRenderingMode(.alwaysOriginal), for: .normal)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.addTarget(self, action: #selector(pressed(button:)), for: .touchUpInside)
       // self.view.addSubview(saveButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
    }
    
    func pressed(button: UIButton!) {
        
        self.storeBook(title: self.lblTitle.text!, publisher: self.lblPublisher.text!, author: self.lblAuthor.text!, category: self.lblCategory.text!,  comments: self.lblComment.text! )
       // goToHomeVC()
    }
    
    func goToHomeVC(){
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    func storeBook(title:String, publisher:String, author: String, category:String, comments:String){

        if title != "" || publisher != "" || author != "" || category != "" {
        
            let post: [String:Any] = ["title":title, "publisher": publisher, "author": author, "category": category, "comments": comments]
           
            databaseRef.child("users").child((user?.uid)!).child(category).child(title).setValue(post)
            uploadImage(category: category)
            _ = self.navigationController?.popToRootViewController(animated: true)
           
        }else{
            
            print("NOTE: Please do not leave it blank!")
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            bookImagePicker.image = image
            imageSelected = true
        }else{
            print("Image Not Selected!")
        }
        imgPicker.dismiss(animated: true, completion: nil)
        imageButton.setTitle("", for: .normal)
    }
   
    @IBAction func selectedImagePicker(_ sender: Any) {
        present(imgPicker, animated: true, completion: nil)
    }
    
    func uploadImage(category: String){
    
        guard let img = bookImagePicker.image, imageSelected == true else {
            print("Image must be selected!")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
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
                        self.databaseRef.child("users").child((self.user?.uid)!).child(category).child(self.lblTitle.text!).child("images").setValue(data)
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func catPicker(){
        let picker = UIPickerView()
        picker.delegate = self
        lblCategory.inputView = picker
    }
    
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        toolbar.barTintColor = .orange
        toolbar.tintColor = .white
        
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([btnDone], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        lblCategory.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



extension AssetFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        lblCategory.text = selectedCat
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

