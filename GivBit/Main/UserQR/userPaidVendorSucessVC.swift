//
//  userPaidVendorSucess.swift
//  GivBit
//
//  Created by Louis Lapat on 7/11/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class userPaidVendorSucessVC: UIViewController {


    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var companyName: UILabel!

    @IBAction func didTapOnXButton(button: UIButton){
        //TO DO - currently, this goes back to the previously screen but we want to go back to the Contacts page after this.
        self.navigationController?.popViewController(animated: true)
    }
    
}
