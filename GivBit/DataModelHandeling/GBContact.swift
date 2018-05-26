//
//  Contact.swift
//  GivBit
//
//  Created by Tallal Javed on 5/16/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Contacts

class GBContact: NSObject {
    
    var name: String = ""
    var lastTransaction: String = ""
    var isFavourite: Bool = false
    var imageData: Data?
    var phoneNumber: String = ""
    var UUID: String = ""
    
    enum ObjectKeys: String{
        case name = "name"
        case imageData = "image_data"
        case phonenumber = "phone_Number"
    }
    
    // Returns a dictionary containing all the contact information
    func dataAsDictionary() -> Dictionary<String, Any>{
        var contactDic = Dictionary<String, Any>()
        contactDic[ObjectKeys.name.rawValue] = self.name
        contactDic[ObjectKeys.imageData.rawValue] = self.imageData
        contactDic[ObjectKeys.phonenumber.rawValue] = self.phoneNumber
        return contactDic
    }
    
    func getUIImageForPlacement(inRect rect: CGRect) -> UIImage{
        if self.imageData == nil{
            // gettting the initials for being drawn on image
            let nameParts = self.name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            var contactInitials = String()
            for part in nameParts{
                contactInitials += String(part.first!)
            }
            
            // Set the UIImage with initials
            //let color = UIColor(gradientStyle:UIGradientStyle.radial, withFrame:CGRect(origin: CGPoint.zero, size: self.contactImage.frame.size), andColors:[ColorsHelper.loginViewColor1!,ColorsHelper.loginViewColor2!])
            let color = UIColor.flatPowderBlue
            let image = UIImage(color: color, size: CGSize(width: rect.width, height: rect.height))
            return ImageHelper.sharedInstance.generateImageWithCenteredText(textAtCenter: contactInitials, inImage: image!, addBackground: false)
            //self.contactImage.image = nil
            
        }else{
            return UIImage(data: self.imageData!)!
        }
    }
    
    func populateWith(CNContact contact: CNContact){
        if contact.phoneNumbers.count > 0{
            self.phoneNumber = contact.phoneNumbers[0].value.stringValue
        }
        if contact.thumbnailImageData != nil{
            self.imageData = contact.thumbnailImageData
        }
        self.name = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)!
    }
    
}
