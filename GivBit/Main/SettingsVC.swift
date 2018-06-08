//
//  SettingsVC.swift
//  GivBit
//
//  Created by Tallal Javed on 5/24/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions
import SVProgressHUD

class SettingsVC: UIViewController {
    
    @IBOutlet weak var unlinkCoinbaseButton: UIButton!
    @IBOutlet weak var linkCoinbaseButton: UIButton!
    @IBOutlet weak var coinbaseEmailLabel: UILabel!
    @IBOutlet weak var fadedViewHolderUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // make all the subviews disapear
        self.fadedViewHolderUIView.subviews.forEach { (view) in
            view.isHidden = true
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        // make the faded view a little rounded on edges
        self.fadedViewHolderUIView.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the top and bottom bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isToolbarHidden = true
        
        if GBCoinbaseUser.sharedInstance.hasUser == false{
            // coinbaseuser info is not present, try to fetch it
            SVProgressHUD.show()
            FirestoreHelper.sharedInstnace.fetchCoinbaseUserInfoObjetForUser(givbitUser: GBUser.sharedUser) { (cbUser, success) in
                SVProgressHUD.dismiss()
                // make all the subviews disapear
                self.fadedViewHolderUIView.subviews.forEach { (view) in
                    view.isHidden = false
                }
                
                if cbUser != nil{
                    self.updateViewForLinkedCoinbase()
                }else if cbUser == nil && success == true{
                    // cb user does not exist in the db
                    self.updateViewForUnlinkedCoinbase()
                }else if success == false{
                    // there was a issue with the netowrk
                    SVProgressHUD.showError(withStatus: "Network Issue, kindly retry")
                }
            }
        }else{
            // make all the subviews visible
            self.fadedViewHolderUIView.subviews.forEach { (view) in
                view.isHidden = false
            }
            // update the ui
            self.updateViewForLinkedCoinbase()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - View
    // updates the view for when user has no coinbase linked to his account
    func updateViewForUnlinkedCoinbase(){
        //UIView.animate(withDuration: 0.5) {
            self.unlinkCoinbaseButton.isHidden = true
            self.linkCoinbaseButton.titleLabel?.text = "Link Coinbase"
            self.coinbaseEmailLabel.text = "No account Linked"
        //}
    }
    
    // updates the view when coinbase is present and user is logged in
    func updateViewForLinkedCoinbase(){
        //UIView.animate(withDuration: 0.5) {
            self.unlinkCoinbaseButton.isHidden = false
            self.linkCoinbaseButton.titleLabel?.text = "Relink"
            self.coinbaseEmailLabel.text = GBCoinbaseUser.sharedInstance.email
        //}
    }
    
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
    
    // unlinks the coinbase account and updates the ui
    @IBAction func didTapOnUnlinkgButton(){
        Functions.functions()
    }

}
