//
//  RequestContactsVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/26/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import SVProgressHUD

class RequestContactsVC: UIViewController {
    @IBOutlet weak var requestContactsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("requestContactsVC")
        
        // Do any additional setup after loading the view.
        self.requestContactsButton.layer.cornerRadius = 5
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
    
    @IBAction func didTapRequestContactsButton(){
        SVProgressHUD.show()

        ContactsManager.sharedInstance.checkAuthorizationStatus { (auth) in
            if auth{
                print("yay")
                // getting the main queue
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    UIApplication.shared.delegate?.window??.rootViewController = storyboard.instantiateInitialViewController()
                    UIApplication.shared.delegate?.window??.makeKeyAndVisible()
                    SVProgressHUD.dismiss()
                }
            }else{
                print("nay")
                SVProgressHUD.dismiss()
                AlertHelper.sharedInstance.showAlert(inViewController: self, withDescription: "Without sharing contacts, you won't be able to send money to any of your friends", andTitle: "Are you sure?", completionHandler: {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        UIApplication.shared.delegate?.window??.rootViewController = storyboard.instantiateInitialViewController()
                        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
                    }
                })
            }
        }
    }
    
}
