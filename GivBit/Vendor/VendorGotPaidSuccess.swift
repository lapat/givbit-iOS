//
//  VendorGotPaidSuccess.swift
//  GivBit
//
//  Created by Louis Lapat on 7/13/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import QRCode

class VendorGotPaidSuccess: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        ImageHelper.sharedInstance.playBackgoundVideo(aView : self.view , videoName :  "purpleBlackFireworks")
    }
    
    @IBAction func didTapOnXButton(button: UIButton){
        //add unwindfunction
    }
}
