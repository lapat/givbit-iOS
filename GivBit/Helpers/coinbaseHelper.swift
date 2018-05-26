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
    let meta = ["send_limit_amount": "1.00", " send_limit_currency": "USD", "send_limit_period": "week"];
    let meta_all = ["account":"all"]
    var loginvc = LoginVC()
    var oauthswift = OAuth2Swift(
        consumerKey:    "dc14823d87efd9398dcb60d79e2f158e7d7f50067213130f8b61d5f6c1c865f0",
        consumerSecret: "9b4fda8e5f6ac55a85af59efdbd6133f53bc5ef3c7966eb3b489edc2ead4339c",
        authorizeUrl: "https://www.coinbase.com/oauth/authorize/",
        accessTokenUrl: "http://www.coinbase.com/oauth/token"  ,
        responseType:   "code"
    )
    
    let coibaseScope = "wallet:accounts:read,wallet:accounts:update,wallet:accounts:create,wallet:accounts:delete,wallet:addresses:read,wallet:addresses:create,wallet:buys:read,wallet:buys:create,wallet:checkouts:read,wallet:checkouts:create,wallet:deposits:read,wallet:deposits:create,wallet:notifications:read,wallet:orders:read,wallet:orders:create,wallet:orders:refund,wallet:payment-methods:read,wallet:payment-methods:delete,wallet:payment-methods:limits,wallet:sells:read,wallet:sells:create,wallet:transactions:read,wallet:transactions:request,wallet:transactions:transfer,wallet:user:read,wallet:user:update,wallet:user:email,wallet:withdrawals:read,wallet:withdrawals:create";
    let redirectUrl = "com.coinbasepermittedcoinoath.apps.coinoath://coinbase-oauth"
    
    var accessToken = ""
    var refreashToken = ""
    func makeLoginupRequest(){
        
        
        oauthswift.authorize(withCallbackURL: URL(string: redirectUrl)!, scope: coibaseScope, state: "",parameters:meta_all,
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
            
            let path = URL(string: redirectUrl)
            oauthswift.postOAuthAccessTokenWithRequestToken(byCode: urlString, callbackURL: path! ,
                                                            success: {credential, response ,parameters in
                                                                
                                                                let  accessToken = credential.oauthToken
                                                                let  refreashToken = credential.oauthRefreshToken
                                                                
                                                                
                                                                if Auth.auth().currentUser?.providerData[0].providerID == "phone"{
                                                                    
                                                                    FirestoreHelper.sharedInstnace.updateCoinbaseidOnCoinbaseWithUUID(universalUserID: (Auth.auth().currentUser?.uid)!, accessToken: accessToken, refreashToken: refreashToken, completionHandler: { (success) in
                                                                    if success == true{
                                                                      self.loginvc.performSegue(withIdentifier: "requestcontactssegue", sender: self)
                                                                    }else{
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                    
                                                                )
                                                                }
                                                                
            },
                                                            failure: {
                                                                error in
                                                                print(error.localizedDescription);
            })
            
            
        }
    }
    
}
