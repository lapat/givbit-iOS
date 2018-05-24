//
//  ReviewLoginVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/8/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase

class ReviewLoginVC: LoginVC {
    
    //MARK: - Variables
    @IBOutlet var phoneVerifiedLabel: UILabel!
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: - Default VC Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.updateUIForUserLogIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Actions
    // takes the user info and adds it to firestore
    @IBAction func userPressedSubmitProfileChnagesButton(){
        // create a user object
        let user = GBUser()
        user.fullName = nameTextField.text!
        user.uuid = (Auth.auth().currentUser?.uid)!
        user.phoneNumber = Auth.auth().currentUser!.phoneNumber!
        FirestoreHelper.sharedInstnace.saveLoggedInFirebaseUser(givbitUser: user)
        
    }
    
    //MARK: - UI Updates
    // This updates the UI With respect to users connected accounts
    func updateUIForUserLogIn(){
        for provider in Auth.auth().currentUser!.providerData{
            if provider.providerID == "facebook.com"{
               // self.fbLoggedInLabel.text = self.fbLoggedInLabel.text! + " Logged In"
            }
            if provider.providerID == "phone"{
                self.phoneVerifiedLabel.text = self.phoneVerifiedLabel.text! + "Verified"
            }
            print("provider ID: " + provider.providerID)
        }
        
        if Auth.auth().currentUser?.providerData[0].providerID == "phone"{
            FirestoreHelper.sharedInstnace.fetchUserWithUUID(universalUserID: (Auth.auth().currentUser?.uid)!) { (user, success) in
                // Check if user already exists in the database
                if success == true{
                    if user != nil{
                        // load the main storyboard
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        UIApplication.shared.delegate?.window??.rootViewController = storyboard.instantiateInitialViewController()
                    }else{
                        // add the new user to DB
                        self.removeBlurFromFullView()
                    }
                }
            }
        }
    }
    
    // Call this to add a blur view to the full view.
    func addBlurToFullView(){
        self.blurVisualEffectView.isHidden = false
    }
    
    func removeBlurFromFullView(){
        self.blurVisualEffectView.isHidden = true
    }
    //MARK: - Login Status
    
}
