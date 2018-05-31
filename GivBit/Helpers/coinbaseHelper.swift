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

class coinbaseoauth : NSObject{
    
    static var sharedInstnace = coinbaseoauth()
    let meta_all_data = ["":"meta[send_limit_period]=day&meta[send_limit_currency]=USD&meta[send_limit_amount]=1.00&account=all"]
    
    var loginvc = LoginVC()
    var oauthswift = OAuth2Swift(
        consumerKey:    "2303625dda9f8ed8a5dd76f111106897069b8b2a6126972718240d50315111a7",
        consumerSecret: "",
        authorizeUrl: "https://www.coinbase.com/oauth/authorize/",
        accessTokenUrl: "http://www.coinbase.com/oauth/token"  ,
        responseType:   "code"
    )
    
    let coibaseScope = "wallet:user:email,wallet:user:read,wallet:buys:create,wallet:buys:read,wallet:payment-methods:read,wallet:accounts:read,wallet:addresses:read,wallet:transactions:send,wallet:addresses:create"//,wallet:transactions:send:bypass-2fa"
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
        
        var urlString = url.absoluteString
        if urlString.lowercased().range(of:redirectUrl) != nil {
            
            let StringToRemove = redirectUrl+"?code=";
            if let range = urlString.range(of: StringToRemove) {
                urlString.replaceSubrange(range, with: "")
            }
            if Auth.auth().currentUser?.providerData[0].providerID == "phone"{
                FirestoreHelper.sharedInstnace.updateCoinbaseidOnCoinbaseWithUUID(universalUserID: (Auth.auth().currentUser?.uid)!, code: urlString, completionHandler: { (success) in
                    if success == true{
                        self.loginvc.performSegue(withIdentifier: "requestcontactssegue", sender: self)
                    }else{
                        
                    }
                })
            }
            let path = URL(string: redirectUrl)
        }
    }
    
}
