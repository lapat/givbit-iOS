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
    static func createInvoiceForVendor(amountUSD: Double, completionHandler: @escaping (_ invoiceCode: String,_ btcAmount: String, Error?) -> Void){
        let data = ["amount": amountUSD]
        Functions.functions().httpsCallable("createInvoice").call(data) { (result, error) in
            let data = result?.data as? Dictionary<String, Any>
            if data != nil{
                print("Invoice created succes")
                print(data)
                let transCode = data!["success"] as! String
                //newDetail.setQuantity(String(format: "%@", quantity))
                let btcAmount = String(format: "%@", data!["btcAmount"] as! CVarArg)
                print("transCode")
                print(transCode)
                print("btcAmount")
                print(btcAmount)
                completionHandler(transCode, btcAmount, nil)
            }
            if error != nil{
                print("got error createInvoiceForVendor")
                print(error?.localizedDescription)
                completionHandler("", "", error)
            }
        }
    }
    static func getInvoiceData(invoiceId: String, completionHandler: @escaping (_ currencyAmount: Double, _ btcAmount: Double, _ companyName: String, _ status: String, Error?) -> Void){
        print("getInvoiceData")
        let data = ["invoiceId": invoiceId]
        Functions.functions().httpsCallable("getInvoiceData").call(data) { (result, error) in
            let data = result?.data as? Dictionary<String, Any>
            if data != nil{
                print("getInvoiceData success")
                print(data)
                let currencyAmount = data!["currencyAmount"] as! Double
                let btcAmount = data!["btcAmount"] as! Double
                let companyName = data!["companyName"] as! String
                let status = data!["status"] as! String
                //print("currencyAmount:"+currencyAmount+" btcAmount:"+btcAmount+" companyName:"+companyName)
                print("companyName:"+companyName)
                completionHandler(currencyAmount, btcAmount, companyName, status, nil)
            }
            if error != nil{
                print("got error getInvoiceData")
                print(error?.localizedDescription)
                completionHandler(0, 0, "", "", error)
            }
        }
    }
    //payInvoice(invoiceId: givBitTransactionCode!) { (success, error) in
    static func payInvoice(invoiceId: String, completionHandler: @escaping (_ success: String, Error?) -> Void){
        print("payInvoice invoiceId:"+invoiceId)
        let data = ["invoiceId": invoiceId]
        Functions.functions().httpsCallable("payInvoice").call(data) { (result, error) in
            let data = result?.data as? Dictionary<String, Any>
            if data != nil{
                print("data is not nil - payInvoice")
                print(data)
                if let success = data!["success"] {
                    let success = data!["success"] as! String
                    print("success:"+success)
                    completionHandler(success, nil)
                    // now val is not nil and the Optional has been unwrapped, so use it
                }
                if let errorMsg = data!["error"] {
                    let errorMsg = data!["error"] as! String
                    print("error:"+errorMsg)
                    let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: errorMsg])
                    completionHandler("false", error)
                    // now val is not nil and the Optional has been unwrapped, so use it
                }

            }
            if error != nil{
                print("got error payInvoice")
                print(error?.localizedDescription)
                completionHandler("false", error)
            }
        }
    }
    
    static func cancelInvoice(invoiceId: String, completionHandler: @escaping (_ success: String, Error?) -> Void){
        print("cancelInvoice-")
        let data = ["invoiceId": invoiceId]
        Functions.functions().httpsCallable("cancelInvoice").call(data) { (result, error) in
            let data = result?.data as? Dictionary<String, Any>
            if data != nil{
                print("cancelInvoice success")
                print(data)
                let success = data!["success"] as! String
                //print("currencyAmount:"+currencyAmount+" btcAmount:"+btcAmount+" companyName:"+companyName)
                print("success:"+success)
                completionHandler(success, nil)
            }
            if error != nil{
                print("got error cancelInvoice")
                print(error?.localizedDescription)
                completionHandler("false", error)
            }
        }
    }
    
   
}
