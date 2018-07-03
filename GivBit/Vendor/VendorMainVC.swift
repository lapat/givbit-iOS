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
    @IBOutlet weak var submitButton: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // remove the top bar
        self.navigationController?.navigationBar.isHidden = true
        
        self.backView.layer.cornerRadius = 5
        self.submitButton.layer.cornerRadius = 5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Actions
    @IBAction func didTapOnCancelButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapContinueButton (button: UIButton){
        // Check if vendor is logged in or not.
        SVProgressHUD.show()
        
        FirestoreHelper.sharedInstnace.checkIfUserIsVendor { (status, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                // maybe network issue occured
                self.dismiss(animated: true, completion: {
                    AlertHelper.sharedInstance.showAlert(inViewController: (UIApplication.shared.keyWindow?.rootViewController)!, withDescription: "Error", andTitle: (error!.localizedDescription))
                })
            }else{
                if status == true{
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
