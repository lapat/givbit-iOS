//
//  VendorLoginVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/21/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class VendorLoginVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // round the relevant views
        self.submitButton.layer.cornerRadius = 5
        self.backView.layer.cornerRadius = 5
        
        // top bar
        self.navigationController?.navigationBar.isHidden = true
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
        if segue.identifier == "invoiceGenSegue"{
            
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapOnCrossButton(){
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func didTapOnSubmitButton(){
        // get the values from tableview
        let firstCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0))
        let nameLabel: UITextField = firstCell?.viewWithTag(1) as! UITextField
        let name = nameLabel.text
        
        let secondCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        let emailLabel: UITextField = secondCell?.viewWithTag(1) as! UITextField
        let email = emailLabel.text
        
        let thirdCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0))
        let emailConfirmationSwitch: UISwitch = thirdCell?.viewWithTag(1) as! UISwitch
        let emailConfirmationsSwitchVal = emailConfirmationSwitch.isOn
        
        // check if the email is valid or not
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if  emailTest.evaluate(with: email) != true{
            // invalid email
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Invalid Email, kindly input a valid email address", andTitle: "Invalid Email")
            return
        }
        
        if (name?.count)! <= 0{
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Kindly give a valid business name", andTitle: "Invalid Name")
            return
        }
        
        SVProgressHUD.show()
        FirebaseHelper.updateVendorSettings(companyName: name!, vendorEmail: email!, shouldEmail: emailConfirmationsSwitchVal) { (error) in
            SVProgressHUD.dismiss()
            if error != nil{
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: (error?.localizedDescription)!, andTitle: "Error")
            }else{
                self.performSegue(withIdentifier: "invoiceGenSegue", sender: self)
            }
        }
    }
}

//MARK: - UITable

extension VendorLoginVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "1")
            return cell!
        }
        if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "2")
            return cell!
        }
        if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "3")
            return cell!
        }
        
        return UITableViewCell()
    }
}
