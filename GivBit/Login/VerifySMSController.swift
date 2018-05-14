//
//  VerifySMSController.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerifySMSController: LoginVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // MARK: - Variables
    @IBOutlet var verificationCodeInputTextField: UITextField!
    
    //MARK: - Actions
    @IBAction func didTapOnVerifySMSButton(button: UIButton){
        // the verficiation ID given by firebase in previous step
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        // Creating the cred object for firebase
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCodeInputTextField.text!)
        
        // Call firebase cred server to verify login
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
                return
            }
            // User is signed in
            // ...
            print(user?.phoneNumber ?? "")
            self.performSegue(withIdentifier: "EditProfile-Segue", sender: self)
        }
    }

}
