//
//  LoginViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 04/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

protocol DataSentDelegate {
    func userEmailData(data: String)
}

class ViewController: UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
  
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    
    var userId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        if Auth.auth().currentUser != nil{
            self.toMyPlanetVC()
        }
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            toMyPlanetVC()
        }
        */
        if UserDefaults.standard.bool(forKey: "login")
        {
            self.toMyPlanetVC()
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        if let info = notification.userInfo{
            
            let rect = (info["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            //let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations: {
            
                self.view.layoutIfNeeded()
                self.btnBottomConstraint.constant = rect.height+20
            })
        }
    }
    
    @IBAction func signIn(_ sender: Any){
        if emailField.text != nil && passwordField.text != nil{
        if let email = emailField.text, let password = passwordField.text{
            
            Auth.auth().signIn(withEmail: email, password: password, completion:
                {(user,error) in
                if error == nil {
                    if let user = user {
                        UserDefaults.standard.set(true, forKey: "login")
                        self.userId = user.uid
                        self.toMyPlanetVC()//homepage
                        }
                }else{
                        self.toCreateUserVC()//register
                    }
            });
        }
        }
    }
    
    //TO Sign up page
    func toCreateUserVC(){
        performSegue(withIdentifier: "SignUp", sender: nil)
    }
    
    //To Home page
    func toMyPlanetVC(){
        performSegue(withIdentifier: "ToMyPlanet", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUp"{
            if let destination = segue.destination as? UserViewController{
                if userId != nil {
                    destination.userId = userId
                }
                if emailField.text != nil {
                    destination.emailField = emailField.text
                }
                if passwordField.text != nil {
                    destination.passwordField = passwordField.text
                }
            }
        }
    }


}

