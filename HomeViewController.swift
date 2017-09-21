//
//  HomeViewController.swift
//  MARS
//
//  Created by Abdul Faiz Mohideen Kannu on 10/07/2017.
//  Copyright © 2017 FaizM. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class HomeViewController: UIViewController{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var lblBookCount: UILabel!
    @IBOutlet weak var lblDVDCount: UILabel!
    @IBOutlet weak var lblCDCount: UILabel!
    
    let dataManager = DataManager()
    static var btn_index: Int!
    
     let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        self.setUserProfileData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut_touchUpInside(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "login")
            
        }catch let logoutError{
            print("ERROR", logoutError)
        }
        self.toLoginVC()
    }
    
    func toLoginVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func setUserProfileData(){
        //get reference to data location
        let databaseRef = Database.database().reference()
        
        //get current user id
        let user = Auth.auth().currentUser
        
        if user != nil
        {
            databaseRef.child("users").child((user?.uid)!).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let userName = value? ["username"] as? String ?? ""
                let userEmail = value? ["email"] as? String ?? ""
                let userImgUrl = value? ["userImg"] as? String ?? ""
                
                self.usernameLbl.text = userName
                self.userEmailLbl.text = userEmail
                
                self.profileImage.loadImageUsingCacheWithUrlString(urlString: userImgUrl)
                
                self.getBooks()
                self.getCDs()
                self.getDVD()
            })
        }
    }
    
    @IBAction func goToScanner(_ sender: UIButton!) {
        HomeViewController.btn_index = 1
    }
    
    @IBAction func setCDVCIndex(_ sender: AnyObject) {
        HomeViewController.btn_index = 2
    }
    
    
    func getBooks()
    {
        var totalBook : Int = 0
        
        Database.database().reference().child("users/\(user!.uid)/Books").observeSingleEvent(of: .value, with: {(Snapshot) in
            
            if let eachDict = Snapshot.value as? NSDictionary{
                print(eachDict)
                for each in eachDict{
                   print(each)
                    totalBook+=1
                    self.lblBookCount.text = "\(totalBook)"
                }
            }
            
        }, withCancel: {(Err) in
            
            print("Error: ",Err)
            // Handle error encountered while communicating with firebase
            
        })
        
    }

    func getCDs()
    {
        Database.database().reference().child("users/\(user!.uid)/CD").observeSingleEvent(of: .value, with: {(Snapshot) in
            
            var totalCD : Int = 0
            
            if let eachDict = Snapshot.value as? NSDictionary{
                // print(eachDict)
                for each in eachDict{
                   print(each)
                    totalCD+=1
                    self.lblCDCount.text = "\(totalCD)"

                }
            }
            
        }, withCancel: {(Err) in
            
            print("Error: ",Err)
            // Handle error encountered while communicating with firebase
            
        })
        
    }
    
    func getDVD()
    {
        Database.database().reference().child("users/\(user!.uid)/DVD").observeSingleEvent(of: .value, with: {(Snapshot) in
            
            var totalDVD : Int = 0
            
            if let eachDict = Snapshot.value as? NSDictionary{
                // print(eachDict)
                for each in eachDict{
                    print(each)
                    totalDVD+=1
                    self.lblDVDCount.text = "\(totalDVD)"
                    
                }
            }
            
            }, withCancel: {(Err) in
                
                print("Error: ",Err)
                // Handle error encountered while communicating with firebase
                
        })

    }
    
        
//         var dvd = [DVDData]()
//        let keyword = ""
//        let finalKeyword = keyword
//        dataManager.requestDVDData(name: finalKeyword){
//            (data, success) in
//            if success{
//                
//                dvd = data as! [DVDData]
//               self.lblDVDCount.text =  "\(dvd.count)"
//                
//            }
//        }
    

    
    // MARK: - Navigation
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    

}
