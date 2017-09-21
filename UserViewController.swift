//
//  UserViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 04/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var finalSignInButton: UIButton!
    

    var userId: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.userEmailField.text = self.emailField
        self.usernameField.delegate = self
    }
    
    @IBAction func selectedImagePicker(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeRegistration(_ sender: Any){
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: {(user, error) in
            if error != nil {
                print("Unable to create user \(error)")
            }else{
                if let user = user {
                    self.userId = user.uid
                    UserDefaults.standard.set(true, forKey: "login")
                }
            }
            self.uploadImage()
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImagePicker.image = image
            imageSelected = true
        }else{
            print("Image wasn't selected!")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(){
        if usernameField.text == nil {
            print("User must provide username!")
            finalSignInButton.isEnabled = false
        }else{
            username = usernameField.text
            finalSignInButton.isEnabled = true
        }
        
        guard let img = userImagePicker.image, imageSelected == true else {
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
                        self.setUpUser(img: url)
                    }
                }
            }
        }
    }

    func setUpUser(img: String){
        let userData = [
        "username": username!,
        "userImg": img,
        "email":emailField!
        ]
        keychain()
        let setLocation = Database.database().reference().child("users").child(userId)
        setLocation.setValue(userData)
    }
    
    func keychain() {
        KeychainWrapper.standard.set(userId, forKey: "uid")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
