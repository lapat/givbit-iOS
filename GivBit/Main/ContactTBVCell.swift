//
//  ContactTBVCell.swift
//  GivBit
//
//  Created by Tallal Javed on 5/14/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit
import Contacts

class ContactTBVCell: UITableViewCell {

    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var contactName: UILabel!
    @IBOutlet var lastTransactionStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Populates the cell with given contact
    func populateCellWithContact(contact: CNContact){
        let thumbnailData = contact.thumbnailImageData
        if thumbnailData != nil{
            self.contactImage.image = UIImage(data: thumbnailData!)
        }
        self.contactName.text = CNContactFormatter.string(from: contact, style: CNContactFormatterStyle.fullName)
    }

}
