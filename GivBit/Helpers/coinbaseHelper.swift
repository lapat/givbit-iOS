//
//  coinbaseAouth.swift
//  CoinBaselib
//
//  Created by Tabish Manzoor on 5/17/18.
//  Copyright © 2018 Tabish Manzoor. All rights reserved.
//

import Foundation
import Firebase
import OAuthSwift
import SVProgressHUD

class coinbaseoauth : NSObject{
    
    static var sharedInstnace = coinbaseoauth()
    let meta_all_data = ["":"meta[send_limit_period]=day&meta[send_limit_currency]=USD&meta[send_limit_amount]=500.00&account=all"]
    
    var loginvc = LoginVC()
    var settingsVC: SettingsVC?
    var oauthswift = OAuth2Swift(
        consumerKey:    "723e663bdd30aac0f9641160de28ce520e1a065853febbd9a9c983569753bcf3",
        consumerSecret: "",
        authorizeUrl: "https://www.coinbase.com/oauth/authorize/",
        accessTokenUrl: "http://www.coinbase.com/oauth/token"  ,
        responseType:   "code"
    )
    
    let coibaseScope = "wallet:user:email,wallet:user:read,wallet:buys:create,wallet:buys:read,wallet:payment-methods:read,wallet:accounts:read,wallet:addresses:read,wallet:transactions:send,wallet:transactions:send:bypass-2fa,wallet:addresses:create&meta[send_limit_amount]=500.00&meta[send_limit_currency]=USD&meta[send_limit_period]=day"
    let redirectUrl = "com.givbitapp.apps.coinflash-12345678://coinbase-oauth"
    var accessToken = ""
    var refreashToken = ""
    func makeLoginupRequest(){
        
        oauthswift.authorize(withCallbackURL: URL(string: redirectUrl)!, scope: coibaseScope, state: "",parameters:meta_all_data,
                             success: {
                                credential, response, parameters in
                                let s = ""//credential.oauth_token
                                
        },
                             failure: {
                                error in
                                let s = (error.localizedDescription);
                                
        })
    }
    
    func getAccessToken(url: URL){
        print("getAccessToken")
        SVProgressHUD.show()

        var urlString = url.absoluteString
        if urlString.lowercased().range(of:redirectUrl) != nil {
            
            let StringToRemove = redirectUrl+"?code=";
            if let range = urlString.range(of: StringToRemove) {
                urlString.replaceSubrange(range, with: "")
            }
            if Auth.auth().currentUser?.providerData[0].providerID == "phone"{
                FirestoreHelper.sharedInstnace.updateCoinbaseidOnCoinbaseWithUUID(universalUserID: (Auth.auth().currentUser?.uid)!, code: urlString, completionHandler: { (success, email) in
                    print(success)
                    print("back from updateCoinbaseidOnCoinbaseWithUUID")
                    SVProgressHUD.dismiss()
                    if success == false{
                        print("ERROR calling updateCoinbaseidOnCoinbaseWithUUID")
                    }else{
                        if self.settingsVC == nil{
                            self.loginvc.performSegue(withIdentifier: "requestcontactssegue", sender: self)
                        }else{
                            print("posting notification email:")
                            print(email)
                            let emailDict:[String: String] = ["email": email]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishedLinkingCoinbase"), object: nil, userInfo: emailDict)
                        }
                    }
                })
            }
            let path = URL(string: redirectUrl)
        }
    }
    
}
