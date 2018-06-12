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
            print("result:")
            print(result?.data)
            print("error:")
            print(error?.localizedDescription)
            completionHandler(error)
        }
    }
}
