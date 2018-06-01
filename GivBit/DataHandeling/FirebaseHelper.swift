//
//  FirebaseHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/30/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase

enum CryptoType: String{
    case btc = "BitCoin"
}

enum FiatType: String{
    case dollar = "Dollar"
}

class FirebaseHelper: NSObject {
    static let sharedInstance = FirebaseHelper()
    
    // fetches the given crypto price for given fiat
    func getCryptoPriceForCurrency(crypto: CryptoType, fiat: FiatType){
        
    }
    
    // functions
}
