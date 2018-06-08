//
//  GBTransaction.swift
//  GivBit
//
//  Created by Tallal Javed on 5/26/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class GBTransaction: NSObject {
    var cryptoAmount: Double!
    var coinbaseItemID: String!
    var date: TimeInterval!
    var pending: Bool!
    var recieverPhoneNumber: String!
    var recieverUID: String!
    var senderUID: String!
    
    override init() {
        
    }
}
