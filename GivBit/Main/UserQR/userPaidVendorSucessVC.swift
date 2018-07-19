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
        
        DispatchQueue.main.async {
            //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            //navigationController?.popToRootViewController(animated: true)
            //self.performSegue(withIdentifier: "unwindToMain", sender: self)
            //self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "unwindToMain", sender: self)

            self.navigationController?.popToRootViewController(animated: true)
            //self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            
            //self.dismiss(animated: true, completion: nil)
            print("x out")
            //self.dismiss(animated: true, completion: {
            //    print("dismissed")
            //self.performSegue(withIdentifier: "unwindToMain", sender: self)
            //})
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        ImageHelper.sharedInstance.playBackgoundVideo(aView : self.view , videoName :  "success2")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDissapear - SendCoinSuccess")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        ImageHelper.sharedInstance.removeVideo();
    }
    
}
