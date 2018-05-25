//
//  GBKeyboardProtocol.swift
//  GivBit
//
//  Created by Tallal Javed on 5/25/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

protocol GBTextFieldDelegate : UITextFieldDelegate {
    func didPressBackspace(textField : GBTextField)
}

class GBTextField: UITextField{
    override func deleteBackward() {
        // If conforming to our extension protocol
        if let pinDelegate = self.delegate as? GBTextFieldDelegate {
            pinDelegate.didPressBackspace(textField: self)
        }
        super.deleteBackward()
    }
}
