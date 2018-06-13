//
//  TransactionTBVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/26/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class GBTransactionTVC: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var fiatAmountLabel: UILabel!
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // populates the transaction using givbit transaction item
    func populateCellWithGBTransanctions(transaction: GBTransaction){
        numberLabel.text = transaction.recieverPhoneNumber
        cryptoAmountLabel.text = String(format: "BTC %.6f", transaction.cryptoAmount)
        let senderNameStr = transaction.senderName
        let receiverNameStr = transaction.recieverName
        nameLabel.text = senderNameStr! + " sent to " + receiverNameStr!
        // set the time interval
        let transactionDate = Date.init(timeIntervalSince1970: transaction.date)
        DateaHelper.getTimeSinceStringFrom(timeInterval: transaction.date)
        // generate the date since string
        let dateSinceString = DateaHelper.getTimeSinceStringFrom(timeInterval: transaction.date)
        timeSinceLabel.text = dateSinceString
        
        // get the price of btc and set it
        FirestoreHelper.sharedInstnace.getBTCPriceInDollars { (value, status) in
            if status{
                if (transaction.sent){
                    self.fiatAmountLabel.text = String(format: "- $%.2f", value! * transaction.cryptoAmount)
                    self.fiatAmountLabel.textColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
                }else{
                    self.fiatAmountLabel.text = String(format: "+ $%.2f", value! * transaction.cryptoAmount)
                    self.fiatAmountLabel.textColor = UIColor(red: 70/255, green: 250/255, blue: 78/255, alpha: 1.0)
                }
            }
        }
        
        print (transactionDate)
    }
}
