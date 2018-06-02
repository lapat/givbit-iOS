//
//  SendCoinSuccesVC.swift
//  GivBit
//
//  Created by Tallal Javed on 6/2/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class SendCoinSuccesVC: UIViewController {
    
    var amountSentInFiat: Double!
    var amountSentInCrypto: Double!
    var nameOfreciever: String!
    var phoneNumberOfReciever: String!
    
    @IBOutlet weak var amountSentFiatPlusCryptoLabel: UILabel!
    @IBOutlet weak var nameOfrecieverLabel: UILabel!
    @IBOutlet weak var phoneNumberOfRecieverLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameOfrecieverLabel.text = nameOfreciever
        phoneNumberOfRecieverLabel.text = phoneNumberOfReciever
        let x = String(format: "$ %.2f (%.5f BTC)", amountSentInFiat,amountSentInCrypto)
        amountSentFiatPlusCryptoLabel.text = x
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
