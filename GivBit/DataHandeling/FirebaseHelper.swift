//
//  FirebaseHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/30/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions

enum CryptoType: String{
    case btc = "BitCoin"
}

enum FiatType: String{
    case dollar = "Dollar"
}

class FirebaseHelper: NSObject {
    static let sharedInstance = FirebaseHelper()
    
    // MARK: - Functions
    // fetches the given crypto price for given fiat
    func getCryptoPriceForCurrency(crypto: CryptoType, fiat: FiatType){
        
    }
    
    // MARK: - Functions
    static func executeUnlinkCoinbaseFunction(completionHandler: @escaping (_ error: Error?) -> Void){
        Functions.functions().httpsCallable("unLinkCoinbase").call { (result, error) in
            print("executeUnlinkCoinbaseFunction returned")
            if let textResult = (result?.data as? [String: Any])?["text"] as? String {
                print("textResult:")
                print(textResult)
            }
            completionHandler(error)
        }
    }
    
    // used to update logged in users vendor settings
    static func updateVendorSettings(companyName: String, vendorEmail: String, shouldEmail: Bool, completionHandler: @escaping (_ error: Error?)->Void){
        // call the firebase func
        let data = ["companyName": companyName, "vendorEmail": vendorEmail, "shouldEmail": shouldEmail] as [String : Any]
        Functions.functions().httpsCallable("updateVendorSettings").call(data) { (result, error) in
            if (error != nil){
                completionHandler(error)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    // sends usd amount to
    static func createInvoiceForVendor(amountUSD: Double, completionHandler: @escaping (_ invoiceCode: String, Error?) -> Void){
        let data = ["amount": amountUSD]
        Functions.functions().httpsCallable("createInvoice").call(data) { (result, error) in
            let data = result?.data as? Dictionary<String, Any>
            if data != nil{
                print(data)
                let transCode = data!["success"] as! String
                completionHandler(transCode, nil)
            }
            if error != nil{
                print(error?.localizedDescription)
                completionHandler("", error)
            }
        }
    }
}
