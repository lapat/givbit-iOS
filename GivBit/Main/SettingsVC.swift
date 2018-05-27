//
//  SettingsVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/24/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    @IBAction func didTapSignOutButton(){
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                let storybaord = UIStoryboard(name: "Login", bundle: nil)
                UIApplication.shared.delegate!.window??.rootViewController = storybaord.instantiateInitialViewController()
                UIApplication.shared.delegate!.window??.makeKeyAndVisible()
            }catch _{
                
            }
        }
    }

}
