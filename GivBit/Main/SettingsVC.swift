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
    // used to show if viewwill appear should refresh the coinbase user or just use the current coinbase user. Since user might have attempted to
    // reconnect a different coinbase
    var userIsRelinkingCoinbase: Bool! = false
    var functions = Functions.functions()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad - SettingsVC")
        // Do any additional setup after loading the view.
        // make all the subviews disapear
        self.fadedViewHolderUIView.subviews.forEach { (view) in
            view.isHidden = true
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        // make the faded view a little rounded on edges
        self.fadedViewHolderUIView.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedLinkingCoinbaseWithSuccess), name: NSNotification.Name(rawValue: "finishedLinkingCoinbase"), object: nil)
        
    }
    
    @objc func willEnterForeground(){
        print("willEnterForeground")
    }
    

    @objc func finishedLinkingCoinbaseWithSuccess(_ notification: NSNotification) {
        print("finishedLinkingCoinbase")
        SVProgressHUD.dismiss()
        if let email = notification.userInfo?["email"] as? String {
            print(email)
            self.updateViewForLinkedCoinbase(email: email)
            //Insert code here
            // do something with your image
        }else{
            print("no email in finishedLinkingCoinbaseWithSuccess")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear SettingsVC")
        // hide the top and bottom bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isToolbarHidden = true
        SVProgressHUD.show()
        self.functions.httpsCallable("isCoinbaseTokenValid").call([]) { (result, error) in
            SVProgressHUD.dismiss()
            print("done calling")
            if error != nil{
                print("Error performing function \(String(describing: error?.localizedDescription))")
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                //self.errorToSendToErrorView = error?.localizedDescription
                //self.performSegue(withIdentifier: "failure-trans-segue", sender: self)
            }else{
                print("isCoinbaseTokenValid returned")
                print(result?.data ?? "")
                let data = result?.data as! [String: Any]
                if data["error"] != nil{
                    print("error checking isCoinbaseTokenValid")
                    print(data["error"] as! String)
                }else{
                    let isValid = data["success"] as! Bool
                    if (isValid == false){
                        print("not valid token, have to relink - show unlinked buttons")
                        self.fadedViewHolderUIView.subviews.forEach { (view) in
                            view.isHidden = false
                        }
                        self.updateViewForUnlinkedCoinbase()
                    }else{
                        let email = data["email"] as! String
                        print("valid token - show linked buttons")
                        // make all the subviews visible
                        self.fadedViewHolderUIView.subviews.forEach { (view) in
                            view.isHidden = false
                        }
                        self.updateViewForLinkedCoinbase(email : email)
                    }
                }

            }
        }
        
        
        
        
        /*
        if GBCoinbaseUser.sharedInstance.hasUser == false || userIsRelinkingCoinbase == true{
            self.userIsRelinkingCoinbase = false
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
        */
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
        print("updateViewForUnlinkedCoinbase")
        DispatchQueue.main.async {
            print("setting buttons")
            self.unlinkCoinbaseButton.isHidden = true
            self.linkCoinbaseButton.titleLabel?.text = "Link Coinbase"
            self.coinbaseEmailLabel.text = "No account Linked"
        }
        //UIView.animate(withDuration: 0.5) {
        //}
    }
    
    // updates the view when coinbase is present and user is logged in
    func updateViewForLinkedCoinbase(email: String){
        print(email)
        DispatchQueue.main.async {
            self.unlinkCoinbaseButton.isHidden = false
            self.linkCoinbaseButton.titleLabel?.text = "Relink"
            self.coinbaseEmailLabel.text = email

        }
        //UIView.animate(withDuration: 0.5) {
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
    @IBAction func didTapOnUnlinkCoinbaseButton(){
        SVProgressHUD.show()
        FirebaseHelper.executeUnlinkCoinbaseFunction { (error) in
            SVProgressHUD.dismiss()
            if error != nil{
                print("error in unlinkCoinbase")
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }else{
                self.updateViewForUnlinkedCoinbase()
            }
        }
    }
    
    @IBAction func didTapOnLinkCoinbaseButton(){
        self.userIsRelinkingCoinbase = true
        coinbaseoauth.sharedInstnace.settingsVC = self
        coinbaseoauth.sharedInstnace.makeLoginupRequest()
    }

}
