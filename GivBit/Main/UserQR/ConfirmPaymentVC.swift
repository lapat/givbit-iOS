//
//  ConfirmVendorPurchaseVC.swift
//  GivBit
//
//  Created by Louis Lapat on 7/10/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class ConfirmPaymentVC: UIViewController {

    @IBOutlet weak var payWhoLabel: UILabel!
    @IBOutlet weak var amountToPay: UILabel!
    @IBOutlet weak var btcAmount: UILabel!
    
    var amountToRequestInDouble: Double! = 0.0
    var givBitTransactionCode: String = ""
    var currencyAmount: Double! = 0.0
    var btcAmountConfrim: Double! = 0.0
    var companyName: String = ""
    var errorMessage: String = "Payment did not go through."
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userPaidVendorSuccess"{
            let destinationVC = segue.destination as! userPaidVendorSucessVC
            let currencyAmountString:String = String(format:"%.2f", self.currencyAmount)
            let btcAmountString:String = String(format:"%.8f", self.btcAmountConfrim)
            print("CompanyName:"+self.companyName+" btcAmountString:"+btcAmountString)
            DispatchQueue.main.async {
                destinationVC.amount.text = "$ "+currencyAmountString+" ("+btcAmountString+" BTC) to";
                destinationVC.companyName.text = self.companyName;
            }
        }else if segue.identifier == "userPaidVendorError"{
            let destinationVC = segue.destination as! userPaidVendorErrorVC
            print("Error Message:"+self.errorMessage)
            DispatchQueue.main.async {
              destinationVC.errorMessage.text = self.errorMessage;
            }
        }
    }
    
     @IBAction func didTapOnConfirmPayment(button: UIButton){
        print("confirmPayment givBitTransactionCode= "+givBitTransactionCode)
        SVProgressHUD.show()
        FirebaseHelper.payInvoice(invoiceId: givBitTransactionCode) { (success, error) in
            SVProgressHUD.dismiss()
            print("Success is "+success)
            if (success == "true"){
                print("payInvoiceSuccess")
                DispatchQueue.main.async {
                  self.performSegue(withIdentifier: "userPaidVendorSuccess", sender: self)
                }
            }else{
                print("did NOT get success from payInvoice")
                //TO Do - print error on screen
                self.errorMessage = "There was an error with your payment."
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "userPaidVendorError", sender: self)
                }
            }
            if (error != nil) {
                print("Error performing payInvoice function \(String(describing: error?.localizedDescription))")
                //TO Do - print error on screen
                self.errorMessage = "Error: \(String(describing: error?.localizedDescription))"
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "userPaidVendorError", sender: self)
                }
            }
        }
    }
    
    @IBAction func didTapOnCancelPayment(button: UIButton){
        print("cancelPayment")
        SVProgressHUD.show()
        FirebaseHelper.cancelInvoice(invoiceId: givBitTransactionCode) { (success, error) in
            SVProgressHUD.dismiss()
            print("Success is "+success)
            if (success == "true"){
                print("cancelInvoiceSuccess")
                self.errorMessage = "You cancelled the payment."
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "userPaidVendorError", sender: self)
                }
            }else{
                print("did NOT get success from cancelInvoice")
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Could not cancel invoice.", andTitle: "Error")
            }
            if (error != nil) {
                print("Error performing cancelInvoice function \(String(describing: error?.localizedDescription))")
                self.errorMessage = "Error: \(String(describing: error?.localizedDescription))"

                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: self.errorMessage, andTitle: "Error")
            }
        }
    }
}

