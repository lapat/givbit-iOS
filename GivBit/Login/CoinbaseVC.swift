//
//  CoinbaseVCViewController.swift
//  GivBit
//
//  Created by Tallal Javed on 5/25/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SafariServices

class CoinbaseVC: LoginVC {

    @IBOutlet weak var coinbaseSignUpButton: UIButton!
    @IBOutlet weak var coinbaseLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("coinbaseVC - view didload")
        // Do any additional setup after loading the view.
        coinbaseLoginButton.layer.cornerRadius = 5
        coinbaseSignUpButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        print("viewWillAppear - CoinbaseVC")
        ImageHelper.sharedInstance.removeVideo();
        //view.layer.sublayers = nil


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
    
    @IBAction func didTapOnSignUpWithCoinbase(button: UIButton){
        let svc = SFSafariViewController(url: NSURL(string: "https://www.coinbase.com/join/5924d7298fb60a02816ccc08")! as URL)
        self.present(svc, animated: true, completion: nil)
        print("used sariview")

    }
    
    @IBAction func didTapOnLoginWithCoinbase(button: UIButton){
        //coinbaseoauth().getAccessToken(url: URL(string: "")!)
        coinbaseoauth.sharedInstnace.loginvc = self
        coinbaseoauth.sharedInstnace.makeLoginupRequest()
       // self.performSegue(withIdentifier: "requestcontactssegue", sender: self)
    }
}
