//
//  PhoneNumberHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 6/2/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneNumberHelper: NSObject {
    static let sharedInstance = PhoneNumberHelper()
    
    func parsePhoneNUmber(number: String) -> (countryCode: String, localeString: String, nummber: String, numberWithCountryCode: String){
        let phoneKit = PhoneNumberKit()
        
        do{
            let phoneNumber = try phoneKit.parse(number)
            print(phoneNumber.numberString)
            print(phoneNumber.countryCode)
            print(phoneNumber.nationalNumber)
            print(phoneNumber.numberExtension)
            print(phoneNumber.type)
            
            return ("\(phoneNumber.countryCode)", "", "\(phoneNumber.nationalNumber)", "+\(phoneNumber.countryCode)\(phoneNumber.nationalNumber)")
        }catch{
            
        }
        
        return ("","","","")
    }
}
