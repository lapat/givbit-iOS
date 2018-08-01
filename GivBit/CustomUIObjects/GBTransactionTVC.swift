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
    @IBOutlet weak var memo: UILabel!
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
//        numberLabel.text = transaction.recieverPhoneNumber
        cryptoAmountLabel.text = String(format: "%.6f BTC", transaction.cryptoAmount)
        let senderNameStr = transaction.senderName
        let receiverNameStr = transaction.recieverName
        nameLabel.text = senderNameStr! + " sent to " + receiverNameStr!
        // set the time interval
        let transactionDate = Date.init(timeIntervalSince1970: transaction.date)
        DateaHelper.getTimeSinceStringFrom(timeInterval: transaction.date)
        // generate the date since string
        let dateSinceString = DateaHelper.getTimeSinceStringFrom(timeInterval: transaction.date)
        if (transaction.pending){
            timeSinceLabel.text = "Pending"
            timeSinceLabel.textColor  = UIColor(red: 69/255, green: 79/255, blue: 172/255, alpha: 1.0)
        }else{
            timeSinceLabel.text = dateSinceString
            timeSinceLabel.textColor  = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        }
        memo.text = transaction.memo
        // get the price of btc and set it
        FirestoreHelper.sharedInstnace.getBTCPriceInDollars { (value, status) in
            if status{
                if (transaction.sent){
                    self.fiatAmountLabel.text = String(format: "- $%.2f", value! * transaction.cryptoAmount)
                    self.fiatAmountLabel.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.6)
                }else{
                    self.fiatAmountLabel.text = String(format: "+ $%.2f", value! * transaction.cryptoAmount)
                    self.fiatAmountLabel.textColor = UIColor(red: 123/255, green: 198/255, blue: 79/255, alpha: 1.0)
                }
            }
        }
        
        print (transactionDate)
    }
}
