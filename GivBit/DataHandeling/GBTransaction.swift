//
//  GBTransaction.swift
//  GivBit
//
//  Created by Tallal Javed on 5/26/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class GBTransaction: NSObject {
    var cryptoAmount: String!
    var coinbaseItemID: String!
    var date: Int!
    var pending: Bool!
    var recieverPhoneNumber: String!
    var recieverUID: String!
    var senderUID: String!
    
    override init() {
        
    }
}
