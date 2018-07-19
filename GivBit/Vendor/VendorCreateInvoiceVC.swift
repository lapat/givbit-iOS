//
//  VendorCreateInvoiceVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/22/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class VendorCreateInvoiceVC: UIViewController {

    @IBOutlet weak var fiatLabel: UILabel!
    @IBOutlet weak var genQRCodeButton: UIButton!
    var amountToRequestFormatted: String! = "$00.00"
    var amountToRequestWithoutDot: String! = ""
    var amountToRequestInDouble: Double! = 0.0
    var givBitTransactionCode: String = ""
    var btcAmount: String = ""

    var vendorName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.genQRCodeButton.layer.cornerRadius = 5
        
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
        if segue.identifier == "showQRCodeSegue"{
            let destinationVC = segue.destination as! VendorQRCodeVC
            destinationVC.givbitTransactionCode = givBitTransactionCode
            // get the info
            destinationVC.transactionAmount = self.amountToRequestFormatted
            destinationVC.btcAmountString = self.btcAmount
            FirestoreHelper.sharedInstnace.getUserVendorInfo(fromCache: true) { (info, error) in
                if error == nil{
                    let data = info as! Dictionary<String, Any>
                    DispatchQueue.main.async {
                        destinationVC.vendorNameLabel.text = data["company_name"] as? String
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToCreateInvoiceVC(segue:UIStoryboardSegue) { print("unwinded to createInvoice")}

    
    //MARK: - Actions
    @IBAction func didTapOnGenerateQRCodeButton(button: UIButton){
        
        if amountToRequestInDouble <= 0.01{
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Amount is too low, kindly specify a larger amount.", andTitle: "Sorry")
            return
        }
        
        if amountToRequestInDouble >= 500.00{
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "You can not charge more than $500 a day.", andTitle: "Sorry")
            return
        }
        
        
        SVProgressHUD.show()
        FirebaseHelper.createInvoiceForVendor(amountUSD: amountToRequestInDouble) { (transactionCode, btcAmount, error)            in
            
            SVProgressHUD.dismiss()
            self.givBitTransactionCode = transactionCode
            self.btcAmount = btcAmount
            
            if error != nil{
                // process the error
                //DispatchQueue.main.async {
                //    self.performSegue(withIdentifier: "showQRCodeSegue", sender: self)
                //}
                
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "There was an error when creating that invoice, please contact support.", andTitle: "Error")
                return
                
            }else{
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showQRCodeSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func didTapOnNumpadButton(button: UIButton){
        if button.titleLabel?.text == "C"{
            fiatLabel.text = "$00.00"
            self.amountToRequestFormatted = fiatLabel.text
            self.amountToRequestWithoutDot = ""
            self.amountToRequestInDouble = 0
            return
        }
        let characterPressed = button.titleLabel?.text
        self.appendCharacterToAmount(char: characterPressed!)
        self.fiatLabel.text = self.amountToRequestFormatted
    }
    
    @IBAction func didTapOnCrossButton(button: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func appendCharacterToAmount(char: String){
        self.amountToRequestWithoutDot = self.amountToRequestWithoutDot + char
        self.amountToRequestFormatted = self.amountToRequestWithoutDot.currencyInputFormatting()
        
        let numNoCurrencySymbol = self.amountToRequestFormatted.replacingOccurrences(of: "$", with: "") as String
        let numNoCommaSymbol = numNoCurrencySymbol.replacingOccurrences(of: ",", with: "") as String
        
        self.amountToRequestInDouble = Double(numNoCommaSymbol)
        self.amountToRequestInDouble = Double(round(100 * self.amountToRequestInDouble)/100)
    }

}
