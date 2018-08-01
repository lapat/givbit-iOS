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
import FirebaseFunctions

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
    var functions = Functions.functions()
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
    
    func checkIfCoinbaseUnlinked(){
        let Checked_Already = GlobalVariables.Checked_Already
        if (Checked_Already == "FALSE"){
            print("Checked_Already is False - Checking Coinbase Linkage")
            coinbaseoauth.sharedInstnace.ifCoinbaseTokenInvalidSetGlobalVariableToNotLinked()
            
        }else{
            print("Already Checked CB Linkage, Not Going To Check Again")
        }
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
            //updateCoinbaseidOnCoinbaseWithUUID calls linkCoinbaseWithCode firebase function on server
            if Auth.auth().currentUser?.providerData[0].providerID == "phone"{
                FirestoreHelper.sharedInstnace.updateCoinbaseidOnCoinbaseWithUUID(universalUserID: (Auth.auth().currentUser?.uid)!, code: urlString, completionHandler: { (success, email) in
                    print(success)
                    print("back from updateCoinbaseidOnCoinbaseWithUUID")
                    SVProgressHUD.dismiss()
                    if success == false{
                        print("ERROR calling updateCoinbaseidOnCoinbaseWithUUID")
                    }else{
                        GlobalVariables.Coinbase_Linkage_Status="LINKED"
                        if self.settingsVC == nil || GlobalVariables.Came_From_On_Boarding == "TRUE" {
                            GlobalVariables.Came_From_On_Boarding = "FALSE"
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
    
    func ifCoinbaseTokenInvalidSetGlobalVariableToNotLinked(){
        self.functions.httpsCallable("isCoinbaseTokenValid").call([]) { (result, error) in
            print("done calling isCoinbaseTokenValid")
            if error != nil{
                print("Error performing function isCoinbaseTokenValid \(String(describing: error?.localizedDescription))")
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
                        print("not valid token, setting global variable to not-linked")
                        GlobalVariables.Coinbase_Linkage_Status = "UNLINKED"
                        NotificationCenter.default.post(name: Notification.Name("coinbaseIsUnlinkedNotification"), object: nil)
                        GlobalVariables.Checked_Already = "FALSE"
                    }else{
                        GlobalVariables.Checked_Already = "TRUE"
                        GlobalVariables.Coinbase_Linkage_Status = ""
                    }
                }
            }
        }
    }
    
}
