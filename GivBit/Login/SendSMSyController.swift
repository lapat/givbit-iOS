//
//  Login.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import FirebaseAuth

class SendSMSyController: LoginVC {
    
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
    
    @IBAction func unwindToSendSMSViewController(segue: UIStoryboardSegue){
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func didTapSendSMSButton(button: UIButton){
        PhoneAuthProvider.provider().verifyPhoneNumber("+923218792228", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "VerifySMS-Segue", sender: self)
            }
            // Sign in using the verificationID and the code sent to the user
            
            
        }
        
    }

}
