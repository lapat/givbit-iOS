//
//  userPaidVendorErrorVC.swift
//  GivBit
//
//  Created by Louis Lapat on 7/11/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class userPaidVendorErrorVC: UIViewController {
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func didTapOnXButton(button: UIButton){

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
