//
//  GBCoinbaseUser.swift
//  GivBit
//
//  Created by Tallal Javed on 6/7/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class GBCoinbaseUser: NSObject {
    var country: String!
    var email: String!
    var name: String!
    var nativeCurrency: String!
    var profilePic: String!
    var uid: String!
    // Used for
    var hasUser: Bool = false
    
    static let sharedInstance: GBCoinbaseUser = GBCoinbaseUser()
}
