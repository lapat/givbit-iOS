//
//  SendCoinVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/23/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions
import SVProgressHUD

class SendCoinVC: UIViewController {
    
    var contact: GBContact!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var fiatToSendLabel: UILabel!
    @IBOutlet weak var btcToSendLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    var cryptoPriceInFiat: NSNumber = 0.0
    var amountOfFiatToSend: NSNumber = 0.0
    var cryptoPriceUpdateListener: ListenerRegistration!
    var errorToSendToErrorView: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if contact != nil{
            contactImageView.image = contact.getUIImageForPlacement(inRect: CGRect(x: 0, y: 0, width: contactImageView.frame.width, height: contactImageView.frame.height))
        }
        self.contactNameLabel.text = contact.name
        
        // Round the iamgeview
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.height/2
        self.contactImageView.clipsToBounds = true
        
        // round the button
        sendButton.layer.cornerRadius = 5
        sendButton.clipsToBounds = true
        
        // varify the number
        let (_, _, _, numberWithCode) =  PhoneNumberHelper.sharedInstance.parsePhoneNUmber(number: contact.phoneNumber)
        self.contact.phoneNumber = "+12244201331"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // start the snapshot listener for crypto price update
        self.startCryptoPriceInFiatUpdateListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // stop listening 
        self.cryptoPriceUpdateListener.remove()
    }
    
    // MARK: - Actions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapNumpadButton(button: UIButton){
        fiatToSendLabel.text?.removeFirst()
        fiatToSendLabel.text?.append((button.titleLabel?.text)!)
        
        // tell system that fiat amount has been updated
        self.fiatAmountUpdatedByUser()
    }
    
    @IBAction func didTapDeleteNumButton(button: UIButton){
        self.fiatToSendLabel.text? = "0000"
        self.fiatAmountUpdatedByUser()
    }
    
    // sends the coin
    @IBAction func didTapOnSendCoinButton(button: UIButton){
        // do checks before sending.
        
        if amountOfFiatToSend.doubleValue < 500 && amountOfFiatToSend.doubleValue > 3.5{
            // fiat is good to be sent.
            let functions = Functions.functions()
            print(contact.phoneNumber)
            
            SVProgressHUD.show()
            functions.httpsCallable("sendCrypto").call(["btcAmount": amountOfFiatToSend.doubleValue, "sendToPhoneNumber": self.contact.phoneNumber]) { (result, error) in
                if error != nil{
                    print("Error performing function \(String(describing: error?.localizedDescription))")
                    self.errorToSendToErrorView = error?.localizedDescription
                    self.performSegue(withIdentifier: "failure-trans-segue", sender: self)
                }else{
                    print(result?.data ?? "")
                    let data = result?.data as! [String: Any]
                    if data["error"] != nil{
                        //self.errorToSendToErrorView = data["error"] as! String
                        //self.performSegue(withIdentifier: "failure-trans-segue", sender: self)
                        self.performSegue(withIdentifier: "success-trans-segue", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "success-trans-segue", sender: self)
                    }
                }
                SVProgressHUD.dismiss()
            }
        }else{
            AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Invalid Amount", andTitle: "Error")
        }
    }
    
    //MARK:- Price Management
    // starts a listener using firestorehelper, which monitors crypto price in given fiat
    func startCryptoPriceInFiatUpdateListener(){
        self.cryptoPriceUpdateListener =  FirestoreHelper.sharedInstnace.startBTCPriceInDollarsSnapshotListener( completionHandler: { (value) in
            self.cryptoPriceInFiat = value
            
            // update the crypto amount for the given dollars.
            self.fiatAmountUpdatedByUser()
            
        })
    }
    
    // called when a user does some update to the given fiat amount
    func fiatAmountUpdatedByUser(){
        // get the number in that label
        let numString = fiatToSendLabel.text! as NSString
        let num = numString.floatValue
        amountOfFiatToSend = NSNumber(value: num)
        
        // update the btc amount
        self.updateCryptoToSendAmountLabelFor(fiat: amountOfFiatToSend, crypto: CryptoType.btc)
    }
    
    func updateCryptoToSendAmountLabelFor(fiat: NSNumber, crypto: CryptoType){
        let amount = (fiat.doubleValue) / (cryptoPriceInFiat.doubleValue)
        btcToSendLabel.text = String(format: "%f", amount)
        
    }
    
    //MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "failure-trans-segue"{
            let errorVC = segue.destination as! SendCoinErrorVC
            errorVC.errorMessage =  errorToSendToErrorView
        }
        if segue.identifier == "success-trans-segue"{
            let successView = segue.destination as! SendCoinSuccesVC
            successView.amountSentInCrypto = self.amountOfFiatToSend.doubleValue / self.cryptoPriceInFiat.doubleValue
            successView.amountSentInFiat = self.amountOfFiatToSend.doubleValue
            successView.nameOfreciever = self.contact.name
            successView.phoneNumberOfReciever = self.contact.phoneNumber
        }
    }
    
    @IBAction func unwindToSendCoinVC(segue: UIStoryboardSegue){
        
    }
}
