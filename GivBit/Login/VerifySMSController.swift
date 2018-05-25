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

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var firstDigitTextField: UITextField!
    @IBOutlet weak var secondDigitTextField: UITextField!
    @IBOutlet weak var thirdDigitTextField: UITextField!
    @IBOutlet weak var fourthDigitTextField: UITextField!
    @IBOutlet weak var fifthDigitTextField: UITextField!
    @IBOutlet weak var sixthDigitTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - VCFunction
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        verifyButton.layer.cornerRadius = 5
        verifyButton.layer.masksToBounds = true
        
        // set the back button
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
    
    //MARK: - Actions
    @IBAction func didTapOnVerifySMSButton(button: UIButton){
        // check if var code is 6 digits
        var code = firstDigitTextField.text! + secondDigitTextField.text! + thirdDigitTextField.text!
        code = code + fourthDigitTextField.text! + fifthDigitTextField.text! + sixthDigitTextField.text!
        if code.count != 6{
            // all is bad
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Kindly enter correct verification code.", andTitle: "Verification Code") {
                self.firstDigitTextField.text = ""
                self.secondDigitTextField.text = ""
                self.thirdDigitTextField.text = ""
                self.fourthDigitTextField.text = ""
                self.sixthDigitTextField.text = ""
            }
            self.resignFirstResponder()
            return
        }
        
        // the verficiation ID given by firebase in previous step
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        // Creating the cred object for firebase
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: code)
        
        // Call firebase cred server to verify login
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Kindly check your verification code, or internet.", andTitle: "Error")
                return
            }
            // User is signed in
            // ...
            print(authResult?.user.phoneNumber ?? "")
            self.performSegue(withIdentifier: "EditProfile-Segue", sender: self)
        }
        
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if error != nil {
//                // ...
//                return
//            }
//            // User is signed in
//            // ...
//            print(user?.phoneNumber ?? "")
//            self.performSegue(withIdentifier: "EditProfile-Segue", sender: self)
//        }
    }

}

// MARK: - TextField
extension VerifySMSController: GBTextFieldDelegate{
    @IBAction func textFieldDidChange(sender textField: UITextField){
        if textField == firstDigitTextField{
            if (textField.text?.count)! >= 1{
                self.secondDigitTextField.becomeFirstResponder()
            }
        }
        if textField == secondDigitTextField{
            if textField.text!.count >= 1{
                self.thirdDigitTextField.becomeFirstResponder()
            }
        }
        if textField == thirdDigitTextField{
            if textField.text!.count >= 1{
                self.fourthDigitTextField.becomeFirstResponder()
            }
        }
        if textField == fourthDigitTextField{
            if textField.text!.count >= 1{
                self.fifthDigitTextField.becomeFirstResponder()
            }
        }
        if textField == fifthDigitTextField{
            if textField.text!.count >= 1 {
                self.sixthDigitTextField.becomeFirstResponder()
            }
        }
        if textField == sixthDigitTextField{
            if textField.text!.count == 1{
                textField.resignFirstResponder()
                //self.didTapOnVerifySMSButton(button: self.verifyButton)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // say no if range is greater than 1
        if range.length > 1{
            return false
        }
        
        // say no if the new string is greater than 1
        if string.count > 1{
            return false
        }
        
        if (textField.text! + string).count > 1{
            // instead give the text to the one next in line
            if textField == firstDigitTextField{
                secondDigitTextField.text = string
                thirdDigitTextField.becomeFirstResponder()
            }
            if textField == secondDigitTextField{
                thirdDigitTextField.text = string
                fourthDigitTextField.becomeFirstResponder()
            }
            if textField == thirdDigitTextField{
                fourthDigitTextField.text = string
                fifthDigitTextField.becomeFirstResponder()
            }
            if textField == fourthDigitTextField{
                fifthDigitTextField.text = string
                sixthDigitTextField.becomeFirstResponder()
            }
            if textField == fifthDigitTextField{
                sixthDigitTextField.text = string
                sixthDigitTextField.becomeFirstResponder()
            }
            return false
        }
        
        return true
    }
    
    func didPressBackspace(textField: GBTextField) {
        if textField.text!.count >= 1 {
            return
        }
        if textField.text!.count == 0{
            if textField == firstDigitTextField{
                
            }
            if textField == secondDigitTextField{
                self.firstDigitTextField.becomeFirstResponder()
                self.firstDigitTextField.text = ""
            }
            if textField == thirdDigitTextField{
                self.secondDigitTextField.becomeFirstResponder()
                self.secondDigitTextField.text = ""
            }
            if textField == fourthDigitTextField{
                self.thirdDigitTextField.becomeFirstResponder()
                self.thirdDigitTextField.text = ""
            }
            if textField == fifthDigitTextField{
                self.fourthDigitTextField.becomeFirstResponder()
                self.fourthDigitTextField.text = ""
            }
            if textField == sixthDigitTextField{
                self.fifthDigitTextField.becomeFirstResponder()
                self.fifthDigitTextField.text = ""
            }
        }
    }
    
}
