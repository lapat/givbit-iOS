//
//  VendorGotPaidSuccessVC.swift
//  GivBit
//
//  Created by Louis Lapat on 7/13/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class VendorGotPaidSuccessVC: UIViewController {
    @IBOutlet weak var whoPaidYou: UILabel!
    @IBOutlet weak var howMuchTheyPaidYouBtc: UILabel!
    var btcAmountString: String! = ""
    var currencyAmountString: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear - vendorGotPaidSuccess")
        ImageHelper.sharedInstance.playBackgoundVideo(aView : self.view , videoName :  "purpleBlackFireworks")
        self.whoPaidYou.text = "You got paid " + currencyAmountString
        self.howMuchTheyPaidYouBtc.text = self.btcAmountString + " BTC"
        ImageHelper.sharedInstance.playBackgoundVideo(aView : self.view , videoName :  "purpleBlackFireworks")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDissapear - VendorGotPaidSuccess")
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        ImageHelper.sharedInstance.removeVideo();
    }

    
    @IBAction func didTapOnXButton(button: UIButton){
        print("didTapOnXButton")
        self.performSegue(withIdentifier: "unwindToCreateInvoiceVC", sender: self)
    }
}
