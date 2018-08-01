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
    var amountOfBtcInWallet: String!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var fiatToSendLabel: UILabel!
    @IBOutlet weak var btcToSendLabel: UILabel!
   
    @IBOutlet weak var btcLeftInAllWallets: UILabel!

    @IBOutlet weak var phonenUmberLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    var cryptoPriceInFiat: NSNumber = 0.0
    var amountOfFiatToSend: NSNumber = 0.0
    var cryptoPriceUpdateListener: ListenerRegistration!
    var errorToSendToErrorView: String!
    var btcToSend : String!
    var firstLoad: Bool = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user:")
        print(Auth.auth().currentUser?.displayName ?? "")

        // Do any additional setup after loading the view.
        if contact != nil{
            contactImageView.image = contact.getUIImageForPlacement(inRect: CGRect(x: 0, y: 0, width: contactImageView.frame.width, height: contactImageView.frame.height))
        }
//        self.contactNameLabel.text = contact.name
        
        // Round the iamgeview
//        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.height/2
//        self.contactImageView.clipsToBounds = true
        
//        // round the button
//        sendButton.layer.cornerRadius = 2.0
//        sendButton.clipsToBounds = true
        
        // varify the number
//        let (_, _, _, numberWithCode) =  PhoneNumberHelper.sharedInstance.parsePhoneNUmber(number: contact.phoneNumber)
//        self.contact.phoneNumber = numberWithCode // "+12244201331"
//
        if let amountString = fiatToSendLabel.text?.currencyInputFormatting() {
            fiatToSendLabel.text = amountString
        }
//        self.phonenUmberLabel.text = self.contact.phoneNumber
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.handleUnlinkedCoinbaseNotification(_:)), name: NSNotification.Name(rawValue: "coinbaseIsUnlinkedNotification"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear Main")
        coinbaseoauth.sharedInstnace.checkIfCoinbaseUnlinked()
        
        if (self.firstLoad == true){
            print("isfirstload")
            self.firstLoad = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        print("viewWillAppear")
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        // start the snapshot listener for crypto price update
        self.startCryptoPriceInFiatUpdateListener()
//        print("amountOfBtcInWallet")
//        print(self.amountOfBtcInWallet)
//        if (self.amountOfBtcInWallet != ""){
//            self.btcLeftInAllWallets.text = "$"+self.amountOfBtcInWallet + " Remaining"
//        }else{
//            self.btcLeftInAllWallets.text = ""
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUnlinkedCoinbaseNotification(_:)), name: NSNotification.Name(rawValue: "coinbaseIsUnlinkedNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // stop listening
//        self.cryptoPriceUpdateListener.remove()
    }
    
    
    // MARK: - Actions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleUnlinkedCoinbaseNotification(_ notification: Notification){
        handleUnlinkedCoinbase();
    }
    
    func handleUnlinkedCoinbase(){
        print("handleUnlinkedCoinbase")
        let Coinbase_Linkage_Status = GlobalVariables.Coinbase_Linkage_Status
        print("Coinbase_Linkage_Status:"+Coinbase_Linkage_Status)
        if (Coinbase_Linkage_Status == "UNLINKED"){
            DispatchQueue.main.async {
                CustomNotificationManager.sharedInstance.addNotificationAtBottomForCoinbaseRelinking(inViewController: self)
                // self.performSegue(withIdentifier: "settingSegue", sender: self)
            }
        }
    }
    
    @IBAction func didTapNumpadButton(button: UIButton){
        print("didTapNumber")
        if (fiatToSendLabel.text != ""){
            fiatToSendLabel.text?.removeFirst()
        }
        fiatToSendLabel.text?.append((button.titleLabel?.text)!)
        if let amountString = fiatToSendLabel.text?.currencyInputFormatting() {
            fiatToSendLabel.text = amountString
        }
        
        
        self.fiatAmountUpdatedByUser()
    }
    
    @IBAction func didTapDeleteNumButton(button: UIButton){
        self.fiatToSendLabel.text? = "0"
        if let amountString = fiatToSendLabel.text?.currencyInputFormatting() {
            fiatToSendLabel.text = amountString
        }
        self.fiatAmountUpdatedByUser()
    }
    
    @IBAction func didTapOnPayButton(button: UIButton){
        //print(btcToSend + "")
        let btcToSendDouble = Double(btcToSend)
        if (btcToSendDouble == 0){
            print("its 0, don't transition")
        }else{
            performSegue(withIdentifier: "goToContactsView", sender: nil)
        }
    }
    //
    
    // sends the coin
    
    //MARK:- Price Management
    // starts a listener using firestorehelper, which monitors crypto price in given fiat
    func startCryptoPriceInFiatUpdateListener(){
        self.cryptoPriceUpdateListener =  FirestoreHelper.sharedInstnace.startBTCPriceInDollarsSnapshotListener( completionHandler: { (value) in
            self.cryptoPriceInFiat = value
            print(value)
            // update the crypto amount for the given dollars.
            self.fiatAmountUpdatedByUser()
            
        })
    }
    
    // called when a user does some update to the given fiat amount
    func fiatAmountUpdatedByUser(){
        // get the number in that label
        let numString = fiatToSendLabel.text! as NSString
        
        print(numString)
        let num = numString.floatValue
        //THIS IS CONVERTED TO 0?
        //print(num)        
        // strips the $ and , from the given fiat label
        let numNoCurrencySymbol = numString.replacingOccurrences(of: "$", with: "") as NSString
        let numNoCommaSymbol = numNoCurrencySymbol.replacingOccurrences(of: ",", with: "") as NSString
        
        let num2 = numNoCommaSymbol.floatValue
        
        amountOfFiatToSend = NSNumber(value: num2)
        // update the btc amount
        self.updateCryptoToSendAmountLabelFor(fiat: amountOfFiatToSend, crypto: CryptoType.btc)
    }
    
    // updates the crypto label for the given fiat amount
    func updateCryptoToSendAmountLabelFor(fiat: NSNumber, crypto: CryptoType){
        print("updateCryptoToSendAmountLabelFor")
        print(fiat.doubleValue)
        print(cryptoPriceInFiat.doubleValue)
        let amount = (fiat.doubleValue) / (cryptoPriceInFiat.doubleValue)
        btcToSendLabel.text = String(format: "%f", amount)
        btcToSend = String(format: "%f", amount)
    }
    
    //MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToContactsView"{
            if let destinationVC = segue.destination as? MainVC {
                print("segueing to select contact view")
                destinationVC.btcToSend = btcToSend;
                destinationVC.amountOfFiatToSendString = fiatToSendLabel.text!;
                destinationVC.cryptoPriceInFiat = cryptoPriceInFiat;
            }
        }
    }
    
    @IBAction func unwindToSendCoinVC(segue: UIStoryboardSegue){
        
    }
    
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        //guard number != 0 as NSNumber else {
        //   return ""
        // }
        
        return formatter.string(from: number)!
    }
    
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

