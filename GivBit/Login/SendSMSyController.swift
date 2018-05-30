//
//  Login.swift
//  GivBit
//
//  Created by Tallal Javed on 5/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import FirebaseAuth
import CTKFlagPhoneNumber
import SVProgressHUD

class SendSMSyController: LoginVC {
    
    @IBOutlet weak var phoneTextField: CTKFlagPhoneNumberTextField!
    @IBOutlet weak var verifySMSButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        verifySMSButton.layer.cornerRadius = 5
        
        phoneTextField.layer.masksToBounds = true
        phoneTextField.flagButtonEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
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
        let phoneNumber = self.phoneTextField.getFormattedPhoneNumber()
        if phoneNumber == nil{
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Kindly enter a valid phone number!", andTitle: "Sorry")
            return
        }
        
        SVProgressHUD.show()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Please try again")
                return
            }else{
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "VerifySMS-Segue", sender: self)
            }
            // Sign in using the verificationID and the code sent to the user
        }
    }

}
