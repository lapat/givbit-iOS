//
//  FirebaseHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 5/30/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Firebase

enum cryptoType: String{
    case btc = "BitCoin"
}

enum fiatType: String{
    case dollar = "Dollar"
}

class FirebaseHelper: NSObject {
    static let sharedInstance = FirebaseHelper()
    
    // fetches the given crypto price for given fiat
    func getCryptoPriceForCurrency(crypto: cryptoType, fiat: fiatType){
        
    }
}
