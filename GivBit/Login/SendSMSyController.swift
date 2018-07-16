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
import CoreTelephony
import SVProgressHUD


class SendSMSyController: LoginVC {
    
    @IBOutlet weak var phoneTextField: CTKFlagPhoneNumberTextField!
    @IBOutlet weak var verifySMSButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SendSMS")
        // Do any additional setup after loading the view.
        verifySMSButton.layer.cornerRadius = 5
        
        phoneTextField.layer.masksToBounds = true
        phoneTextField.flagButtonEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        // get the locale information
        let _ = NSLocale.current
        
        
        // get the network info - need it for country code
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        
        // set the phone number text field country code ... with respect to the current sims carrier
        //let carrierCountryCode = carrier?.isoCountryCode
        // check if sim is not present or if the user is on a simulator.
        if carrier != nil{
            phoneTextField.setFlag(for: (carrier?.isoCountryCode)!.uppercased())
        }
        ImageHelper.sharedInstance.playBackgoundVideo(aView : self.view , videoName :  "1_7_moresubtle1")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("SendSMS - viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDissapear - sendSMS")
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        ImageHelper.sharedInstance.removeVideo();
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
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Please enter a valid phone number.", andTitle: "Sorry")
            return
        }
        
        SVProgressHUD.show()
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Please try again")
                SVProgressHUD.dismiss()
                return
            }else{
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "VerifySMS-Segue", sender: self)
                SVProgressHUD.dismiss()
            }
            // Sign in using the verificationID and the code sent to the user
        }
    }
}
