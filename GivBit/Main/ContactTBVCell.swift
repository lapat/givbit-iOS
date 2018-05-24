//
//  ContactTBVCell.swift
//  GivBit
//
//  Created by Tallal Javed on 5/14/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Contacts
import ChameleonFramework

class ContactTBVCell: UITableViewCell {
    
    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var contactName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        // round the imageview
        contactImage.layer.cornerRadius = contactImage.frame.height/2
        contactImage.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Populates the cell with given contact
    func populateCellWithContact(contact: CNContact){
        let thumbnailData = contact.thumbnailImageData
        self.contactName.text = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)
        if thumbnailData != nil{
            self.contactImage.image = UIImage(data: thumbnailData!)
        }else{
            // gettting the initials for being drawn on image
            let nameParts = self.contactName.text?.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            var contactInitials = String()
            for part in nameParts!{
                contactInitials += String(part.first!)
            }
            
            // Set the UIImage with initials
            //let color = UIColor(gradientStyle:UIGradientStyle.radial, withFrame:CGRect(origin: CGPoint.zero, size: self.contactImage.frame.size), andColors:[ColorsHelper.loginViewColor1!,ColorsHelper.loginViewColor2!])
            let color = UIColor.flatPowderBlue
            let image = UIImage(color: color, size: CGSize(width: self.contactImage.frame.width, height: self.contactImage.frame.height))
            self.contactImage.image = ImageHelper.sharedInstance.generateImageWithCenteredText(textAtCenter: contactInitials, inImage: image!, addBackground: false)
            //self.contactImage.image = nil
        }
        self.phoneNumber.text = contact.phoneNumbers[0].value.stringValue
    }
    
}
