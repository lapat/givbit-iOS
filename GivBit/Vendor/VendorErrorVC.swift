//
//  VendorErrorVC.swift
//  GivBit
//
//  Created by Louis Lapat on 7/13/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class VendorErrorVC: UIViewController {
    @IBOutlet weak var errorMessageLabel: UILabel!
    var errorMessageString: String! = "Payment did not go through."

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear - vendorGotPaidSuccess")
        self.errorMessageLabel.text = self.errorMessageString;
    }
    
    @IBAction func didTapOnXButton(button: UIButton){
        print("didTapOnXButton")
        self.performSegue(withIdentifier: "unwindToCreateInvoiceVC", sender: self)
    }    
    
}
