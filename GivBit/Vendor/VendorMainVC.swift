//
//  VendorMainVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/21/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class VendorMainVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var vendorSettingsView: UIView!
    @IBOutlet weak var vendorWelcomView: UIView!
    @IBOutlet weak var vendorEmailField: UITextField!
    @IBOutlet weak var vendorBusinessNameField: UITextField!
    @IBOutlet weak var vendorEmailUpdatesAllowedSwitch: UISwitch!
    @IBOutlet weak var createInvoiceButton: UIButton!
    //@IBOutlet weak var saveVendorInfo: UIButton!
    //@IBOutlet weak var createInvoice: UIButton!
//    @IBOutlet weak var nameOfCompany: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // remove the top bar
        self.navigationController?.navigationBar.isHidden = true
        
        self.backView.layer.cornerRadius = 5
        //self.submitButton.layer.cornerRadius = 5
        self.vendorSettingsView.isHidden = true
        self.vendorWelcomView.isHidden = true
       // self.createInvoice.isHidden = true
        
        // add a radius on buttons
        self.submitButton.layer.cornerRadius = 5
        self.createInvoiceButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check if user is a vendor or not
        SVProgressHUD.show()
        FirestoreHelper.sharedInstnace.checkIfUserIsVendor { (status, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                // maybe network issue occured
                self.dismiss(animated: true, completion: {
                    AlertHelper.sharedInstance.showAlert(inViewController: (UIApplication.shared.keyWindow?.rootViewController)!, withDescription: "Error", andTitle: (error!.localizedDescription))
                })
            }else{
                //User is already signed up as vendor
                var aaa = true;
                //CHANGE ME LATER - FOR TESTING
                //if status == true{
                if aaa == true{
                    // move to the vendor signed up view
                    // get the vendor info and update view
                    // visualize the vendor settings view
                    self.vendorSettingsView.isHidden = false
                    self.vendorWelcomView.isHidden = true
                    self.fetchVendorInfoAndUpdateView(userIsVendor: true)
                    self.vendorSettingsView.isHidden = false
//                    self.createInvoice.isHidden = false

                }else{
                    SVProgressHUD.dismiss()
                    self.vendorWelcomView.isHidden = false;
                    // the user needs to login to vendor - Hide the vendor settings
                    self.vendorSettingsView.isHidden = true
                    self.vendorWelcomView.isHidden = false
                }
            }
        }
    }
    

    
    // fetches the vendors info form the db and updates view
    // does this only if user is a vendor
    // enables the vendor settings view and disables the vendor welcome view
    func fetchVendorInfoAndUpdateView(userIsVendor: Bool){
        if userIsVendor == true{
            FirestoreHelper.sharedInstnace.getUserVendorInfo(fromCache: true) { (infoObject, error) in
                SVProgressHUD.dismiss()
                if error != nil{
                    AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Networking Issue", andTitle: "Error")
                    DispatchQueue.main.async {
                        //self.saveVendorInfo.isHidden = true
                    }
                }else{
                    let data = infoObject as! Dictionary<String, Any>
                    let vendorEmail = data["vendor_email"] as! String
                    let companyName = data["company_name"] as! String
                    // manipulate the ui on main thread for sanities sake.
                    DispatchQueue.main.async {
//                        self.nameOfCompany.text = companyName
                        self.vendorEmailField.text = vendorEmail
                        self.vendorBusinessNameField.text = companyName
                        
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapOnCancelButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapContinueButton (button: UIButton){
        print("didTapCont")
        // Check if vendor is logged in or not.
        //SVProgressHUD.show()
        OperationQueue.main.addOperation {
            [weak self] in
            self?.performSegue(withIdentifier: "vendorLoginSegue", sender: self)
        }
        /*
        FirestoreHelper.sharedInstnace.checkIfUserIsVendor { (status, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                // maybe network issue occured
                self.dismiss(animated: true, completion: {
                    AlertHelper.sharedInstance.showAlert(inViewController: (UIApplication.shared.keyWindow?.rootViewController)!, withDescription: "Error", andTitle: (error!.localizedDescription))
                })
            }else{
                //if status == true{
                var aaa = false;
                //CHANGE ME LATER - THIS IS FOR TESTING
                if (aaa == true){
                    // move to the vendor signed up view
                    OperationQueue.main.addOperation {
                        [weak self] in
                        self?.performSegue(withIdentifier: "createInvoiceSegue", sender: self)
                    }
                }else{
                    // the user needs to login to vendor
                    OperationQueue.main.addOperation {
                        [weak self] in
                        self?.performSegue(withIdentifier: "vendorLoginSegue", sender: self)
                    }
                }
            }
         }
 */
        
    }
    

    @IBAction func didTapCreateInvoiceButton(sendor: UIButton){
       print("tapCreate")
        FirestoreHelper.sharedInstnace.saveVendorSettings(name: vendorBusinessNameField.text!, email: vendorEmailField.text!, emailNotificationsAllowed: vendorEmailUpdatesAllowedSwitch.isOn){(err) in
            if err == nil{
                //AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "You vendor info has been updated", andTitle: "Saved")
                OperationQueue.main.addOperation {
                    [weak self] in
                    self?.performSegue(withIdentifier: "createInvoiceSegue", sender: self)
                }
            }else{
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "We were not able to save your info, kindly check your internet", andTitle: "Error")
            }
            
        }
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
