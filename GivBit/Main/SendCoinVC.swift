//
//  SendCoinVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/23/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase

class SendCoinVC: UIViewController {
    
    var contact: GBContact!
    var amountToSendInFIAT: Decimal!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var fiatToSendLabel: UILabel!
    @IBOutlet weak var btcToSendLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    var cryptoPriceInFiat: NSNumber = 0.0
    var fiatToSendAmount: NSNumber = 0.0
    var cryptoPriceUpdateListener: ListenerRegistration!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapNumpadButton(button: UIButton){
        fiatToSendLabel.text?.removeFirst()
        fiatToSendLabel.text?.append((button.titleLabel?.text)!)
    }
    
    @IBAction func didTapDeleteNumButton(button: UIButton){
        self.fiatToSendLabel.text? = "00.00"
    }

    
    //MARK:- Price Management
    // starts a listener using firestorehelper, which monitors crypto price in given fiat
    func startCryptoPriceInFiatUpdateListener(){
        self.cryptoPriceUpdateListener =  FirestoreHelper.sharedInstnace.startBTCPriceInDollarsSnapshotListener( completionHandler: { (value) in
            print(value)
            self.cryptoPriceInFiat = value
            
            // update the crypto amount for the given dollars.
            
        })
    }
    
    // called when a user does some update to the given fiat amount
    func fiatAmountUpdatedByUser(){
        
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
