//
//  User.swift
//  GivBit
//
//  Created by Tallal Javed on 5/16/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//
//  Holds complete information regarding the current logged in user

/*!
 @class GBUser
 
 @brief The GivBit User
 
 @discussion    This class was designed and implemented to hold logged in users structure. Used for storing and retrieving objects from firestore. As this is the standard structure.
 */

import UIKit

class GBUser: NSObject {
    var uuid: String = ""
    var fullName: String = ""
    var phoneNumber: String = ""
    var coinbaseToken: String = ""
    var coinbaseRefreshToken: String = ""
    
    enum ObjectKeys: String{
        case uuid = "uid"
        case fullName = "name"
        case phoneNumber = "phone_number"
        case coinbaseToken = "coinbase_token"
        case coinbaseRefreshToken = "coinbase_refresh_token"
    }
    
    // Returns a dictionary containing all the user information
    func dataAsDictionary() -> Dictionary<String, Any>{
        var userDic = Dictionary<String, Any>()
        userDic[ObjectKeys.uuid.rawValue] = self.uuid
        userDic[ObjectKeys.fullName.rawValue] = self.fullName
        userDic[ObjectKeys.phoneNumber.rawValue] = self.phoneNumber
        userDic[ObjectKeys.coinbaseToken.rawValue] = self.coinbaseToken
        userDic[ObjectKeys.coinbaseRefreshToken.rawValue] = self.coinbaseRefreshToken
        return userDic
    }
}
